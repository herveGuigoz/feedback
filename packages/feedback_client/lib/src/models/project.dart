part of 'models.dart';

@JsonSerializable()
class Project extends Equatable {
  const Project({required this.id, required this.url});

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  /// The unique identifier of the project
  final String id;

  /// The url of the project
  final String url;

  @override
  List<Object?> get props => [id, url];

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
