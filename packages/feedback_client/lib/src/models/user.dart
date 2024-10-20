part of 'models.dart';

@JsonSerializable()
class User extends Equatable {
  const User({required this.id, required this.username});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  final String id;

  final String username;

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, username];
}
