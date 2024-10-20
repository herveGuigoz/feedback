import 'package:feedback_client/feedback_client.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketbaseFeedbackEvent extends FeedbackEvent {
  const PocketbaseFeedbackEvent({
    required super.id,
    required super.path,
    required super.status,
    required super.device,
    required super.screenSize,
    required super.agent,
    required super.content,
    required super.screenshot,
    required super.owner,
    required super.created,
  });

  factory PocketbaseFeedbackEvent.fromRecordModel(RecordModel model) {
    late final String path;
    if (model.data case {'path': final String value}) {
      path = value;
    } else {
      Error.throwWithStackTrace(const FeedbackFindIssuesException('Invalid response (path)'), StackTrace.current);
    }

    late final FeedbackStatus status;
    if (model.data case {'status': final String value}) {
      status = FeedbackStatus.values.firstWhere((e) => e.name == value);
    } else {
      Error.throwWithStackTrace(const FeedbackFindIssuesException('Invalid response (status)'), StackTrace.current);
    }

    late final Device device;
    if (model.data case {'device': final String value}) {
      device = Device.values.firstWhere((e) => e.name == value);
    } else {
      Error.throwWithStackTrace(const FeedbackFindIssuesException('Invalid response (device)'), StackTrace.current);
    }

    late final String screenSize;
    if (model.data case {'screen_size': final String value}) {
      screenSize = value;
    } else {
      Error.throwWithStackTrace(const FeedbackFindIssuesException('Invalid response (screenSize)'), StackTrace.current);
    }

    late final String agent;
    if (model.data case {'agent': final String value}) {
      agent = value;
    } else {
      Error.throwWithStackTrace(const FeedbackFindIssuesException('Invalid response (agent)'), StackTrace.current);
    }

    late final String content;
    if (model.data case {'content': final String value}) {
      content = value;
    } else {
      Error.throwWithStackTrace(const FeedbackFindIssuesException('Invalid response (content)'), StackTrace.current);
    }

    late final String screenshot;
    if (model.data case {'screenshot': final String value}) {
      screenshot = '/api/files/issues/${model.id}/$value';
    } else {
      Error.throwWithStackTrace(const FeedbackFindIssuesException('Invalid response (screenshot)'), StackTrace.current);
    }

    late final FeedbackOwner owner;
    if (model.expand case {'owner': final List<RecordModel> records}) {
      owner = FeedbackOwner.fromJson(records.first.toJson());
    } else {
      Error.throwWithStackTrace(const FeedbackFindIssuesException('Invalid response (owner)'), StackTrace.current);
    }

    return PocketbaseFeedbackEvent(
      id: model.id,
      path: path,
      status: status,
      device: device,
      screenSize: screenSize,
      agent: agent,
      content: content,
      screenshot: screenshot,
      owner: owner,
      created: DateTime.parse(model.created),
    );
  }
}
