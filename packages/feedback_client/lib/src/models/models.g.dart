// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      content: json['content'] as String,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      created: DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'author': instance.author,
      'created': instance.created.toIso8601String(),
    };

FeedbackEvent _$FeedbackEventFromJson(Map<String, dynamic> json) =>
    FeedbackEvent(
      id: json['id'] as String,
      path: json['path'] as String,
      status: $enumDecode(_$FeedbackStatusEnumMap, json['status']),
      device: $enumDecode(_$DeviceEnumMap, json['device']),
      screenSize: json['screenSize'] as String,
      agent: json['agent'] as String,
      content: json['content'] as String,
      screenshot: json['screenshot'] as String,
      owner: FeedbackOwner.fromJson(json['owner'] as Map<String, dynamic>),
      created: DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$FeedbackEventToJson(FeedbackEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'status': _$FeedbackStatusEnumMap[instance.status]!,
      'device': _$DeviceEnumMap[instance.device]!,
      'screenSize': instance.screenSize,
      'agent': instance.agent,
      'content': instance.content,
      'screenshot': instance.screenshot,
      'owner': instance.owner,
      'created': instance.created.toIso8601String(),
    };

const _$FeedbackStatusEnumMap = {
  FeedbackStatus.pending: 'pending',
  FeedbackStatus.inProgress: 'inProgress',
  FeedbackStatus.resolved: 'resolved',
  FeedbackStatus.closed: 'closed',
};

const _$DeviceEnumMap = {
  Device.desktop: 'desktop',
  Device.iPhoneSE: 'iPhoneSE',
};

FeedbackOwner _$FeedbackOwnerFromJson(Map<String, dynamic> json) =>
    FeedbackOwner(
      id: json['id'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$FeedbackOwnerToJson(FeedbackOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
    };

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      id: json['id'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
    };
