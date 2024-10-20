import 'package:feedback_client/feedback_client.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketbaseUser extends User {
  const PocketbaseUser({required super.id, required super.username, required this.token});

  factory PocketbaseUser.fromRecordModel(RecordModel record, String token) {
    late final String username;
    if (record.data case {'username': final String value}) {
      username = value;
    } else {
      Error.throwWithStackTrace(const FeedbackAuthenticateException('Invalid response (username)'), StackTrace.current);
    }

    return PocketbaseUser(id: record.id, username: username, token: token);
  }

  factory PocketbaseUser.fromJson(Map<String, dynamic> json) {
    return PocketbaseUser(
      id: json['id'] as String,
      username: json['username'] as String,
      token: json['token'] as String,
    );
  }

  final String token;

  @override
  List<Object?> get props => [id, username, token];

  @override
  Map<String, dynamic> toJson() => {'id': id, 'username': username, 'token': token};
}
