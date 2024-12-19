import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? id;
  final String? title;
  final String? content;
  final String? image;
  final String? video;
  final String? videoNote;
  final List<String>? likedBy;
  final int? comments;
  final String? type;
  final Timestamp? time;
  final List<String>? category;

  Post({
    this.id,
    this.title,
    this.content,
    this.image,
    this.video,
    this.videoNote,
    this.likedBy,
    this.comments,
    this.type,
    this.time,
    this.category,
  });

  factory Post.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Post(
      id: snapshot.id,
      title: data?['title'],
      content: data?['content'],
      image: data?['image'],
      video: data?['video'],
      videoNote: data?['video note'],
      likedBy: data?['likedBy'] is Iterable ? List.from(data?['likedBy']) : null,
      comments: data?['comments'],
      type: data?['type'],
      time: data?['time'],
      category: data?['category'] is Iterable ? List.from(data?['category']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (content != null) "content": content,
      if (image != null) "image": image,
      if (video != null) "video": video,
      if (videoNote != null) "video note": videoNote,
      if (likedBy != null) "likedBy": likedBy,
      if (comments != null) "comments": comments,
      if (type != null) "type": type,
      if (time != null) "time": time,
      if (category != null) "category": category,
    };
  }
}