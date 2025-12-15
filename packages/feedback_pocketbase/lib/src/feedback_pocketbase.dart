import 'dart:convert';

import 'package:feedback_client/feedback_client.dart';
import 'package:feedback_pocketbase/feedback_pocketbase.dart';
import 'package:feedback_pocketbase/src/models/comment.dart';
import 'package:feedback_pocketbase/src/models/issue.dart';
import 'package:feedback_pocketbase/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:rxdart/rxdart.dart';

/// {@template feedback_pocketbase}
/// A [FeedbackClient] implementation that uses the Pocketbase API.
/// {@endtemplate}
class FeedbackPocketbase implements FeedbackClient {
  /// {@macro feedback_pocketbase}
  FeedbackPocketbase({required this.baseUrl, required this.projectId, FeedbackStorageInterface? storage})
    : _pocketBase = PocketBase(baseUrl, authStore: FeebackAuthStore(storage: storage));

  @override
  final String baseUrl;

  final String projectId;

  final PocketBase _pocketBase;

  @override
  Stream<User?> get user {
    return (_pocketBase.authStore as FeebackAuthStore).user;
  }

  @override
  Future<User> authenticate({required String username, required String password}) async {
    try {
      final result = await _pocketBase.collection('users').authWithPassword(username, password);
      if (result.record case final RecordModel record) {
        _pocketBase.authStore.save(result.token, record);

        return PocketbaseUser.fromRecordModel(record, result.token);
      }
      Error.throwWithStackTrace(const FeedbackAuthenticateException('Invalid response'), StackTrace.current);
    } on FeedbackAuthenticateException catch (_) {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(FeedbackAuthenticateException(e), stackTrace);
    }
  }

  @override
  Future<List<FeedbackEvent>> findFeedbacks(String path) async {
    try {
      final records = await _pocketBase
          .collection('issues')
          .getFullList(
            expand: 'owner',
            sort: '-created',
            filter: 'path="$path" && status!="closed"',
          );
      return records.map(PocketbaseFeedbackEvent.fromRecordModel).toList();
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(FeedbackFindIssuesException(e), stackTrace);
    }
  }

  @override
  Future<FeedbackEvent> createFeedback({required CreateFeedbackRequest request}) async {
    final record = await _pocketBase
        .collection('issues')
        .create(
          body: {
            'status': FeedbackStatus.pending.name,
            'content': request.body,
            'device': request.device,
            'screen_size': request.screenSize,
            'agent': request.agent,
            'owner': (_pocketBase.authStore as FeebackAuthStore).currentUser?.id,
            'project': projectId,
            'path': request.path,
          },
          files: [http.MultipartFile.fromBytes('screenshot', request.image, filename: 'screenshot.png')],
          expand: 'owner',
        );

    return PocketbaseFeedbackEvent.fromRecordModel(record);
  }

  @override
  Future<FeedbackEvent> updateFeedback({required UpdateFeedbackRequest request}) async {
    final feedback = await _pocketBase
        .collection('issues')
        .update(request.id, body: {'content': request.content, 'status': request.status.name}, expand: 'owner');

    return PocketbaseFeedbackEvent.fromRecordModel(feedback);
  }

  @override
  Future<void> deleteFeedback({required String id}) async {
    await _pocketBase.collection('issues').delete(id);
  }

  @override
  Future<List<Comment>> findComments(String issueId) async {
    final records = await _pocketBase
        .collection('comments')
        .getFullList(expand: 'author', filter: 'issue="$issueId"', sort: '-created');
    return records.map(PocketbaseComment.fromRecordModel).toList();
  }

  @override
  Future<Comment> addComment({required AddCommentRequest request}) async {
    final record = await _pocketBase
        .collection('comments')
        .create(
          body: {
            'issue': request.feedback,
            'content': request.content,
            'author': (_pocketBase.authStore as FeebackAuthStore).currentUser?.id,
          },
          expand: 'author',
        );

    return PocketbaseComment.fromRecordModel(record);
  }

  @override
  Future<void> deleteComment({required String id}) async {
    await _pocketBase.collection('comments').delete(id);
  }

  @override
  Future<Comment> updateComment({required UpdateCommentRequest request}) async {
    final record = await _pocketBase
        .collection('comments')
        .update(request.id, body: {'content': request.content}, expand: 'author');

    return PocketbaseComment.fromRecordModel(record);
  }

  @override
  Future<void> logout() async {
    _pocketBase.authStore.clear();
  }
}

class FeebackAuthStore extends AuthStore {
  FeebackAuthStore({FeedbackStorageInterface? storage})
    : _storage = storage ?? InMemoryFeedbackStorage(),
      _user = BehaviorSubject<PocketbaseUser?>() {
    _storage.readUser().then(_user.add);
  }

  final FeedbackStorageInterface _storage;

  late final BehaviorSubject<PocketbaseUser?> _user;

  Stream<User?> get user => _user;

  User? get currentUser => _user.value;

  @override
  void save(String newToken, dynamic newModel) {
    final user = PocketbaseUser.fromRecordModel(newModel as RecordModel, newToken);
    _user.add(user);
    _storage.writeUser(user: user);
    super.save(newToken, newModel);
  }

  @override
  void clear() {
    super.clear();
    _storage.deleteUser();
  }
}

extension on FeedbackStorageInterface {
  Future<PocketbaseUser?> readUser() async {
    final user = await read('pocketbase_user');
    if (user == null) {
      return null;
    }
    return PocketbaseUser.fromJson(jsonDecode(user) as Map<String, dynamic>);
  }

  Future<void> writeUser({required PocketbaseUser user}) async {
    await write(key: 'pocketbase_user', value: jsonEncode(user.toJson()));
  }

  Future<void> deleteUser() async {
    await delete('pocketbase_user');
  }
}
