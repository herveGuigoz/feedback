// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackEvent _$FeedbackEventFromJson(Map<String, dynamic> json) =>
    FeedbackEvent(
      id: json['id'] as String,
      url: json['url'] as String,
      status: $enumDecode(_$FeedbackStatusEnumMap, json['status']),
      body: json['body'] as String,
      image: FeedbackImage.fromJson(json['image'] as Map<String, dynamic>),
      owner: FeedbackOwner.fromJson(json['owner'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$FeedbackEventToJson(FeedbackEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'status': _$FeedbackStatusEnumMap[instance.status]!,
      'body': instance.body,
      'image': instance.image,
      'owner': instance.owner,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$FeedbackStatusEnumMap = {
  FeedbackStatus.pending: 'pending',
  FeedbackStatus.inProgress: 'inProgress',
  FeedbackStatus.resolved: 'resolved',
  FeedbackStatus.closed: 'closed',
};

FeedbackImage _$FeedbackImageFromJson(Map<String, dynamic> json) =>
    FeedbackImage(
      contentUrl: json['contentUrl'] as String,
    );

Map<String, dynamic> _$FeedbackImageToJson(FeedbackImage instance) =>
    <String, dynamic>{
      'contentUrl': instance.contentUrl,
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

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
    };
