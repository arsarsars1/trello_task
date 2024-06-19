import 'package:hive/hive.dart';

part 'comment_model.g.dart';

@HiveType(typeId: 2)
class CommentModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String comment;
  @HiveField(2)
  final String createdAt;

  CommentModel({
    required this.id,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'comment': comment,
        'createdAt': createdAt,
      };

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      comment: json['comment'],
      createdAt: json['createdAt'],
    );
  }
}
