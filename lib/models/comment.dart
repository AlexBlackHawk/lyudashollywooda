// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Comment {
//   final String? id;
//   final String? avatar;
//   final String? email;
//   final String? name;
//   final String? role;
//   final bool? isOnline;
//   final Timestamp? time;
//   final String? phoneNumber;
//
//   Comment({
//     this.id,
//     this.avatar,
//     this.email,
//     this.name,
//     this.role,
//     this.isOnline,
//     this.lastOnline,
//     this.phoneNumber,
//   });
//
//   factory Comment.fromFirestore(
//       DocumentSnapshot<Map<String, dynamic>> snapshot,
//       SnapshotOptions? options,
//       ) {
//     final data = snapshot.data();
//     return Comment(
//       id: snapshot.id,
//       avatar: data?['avatar'],
//       email: data?['email'],
//       name: data?['name'],
//       role: data?['role'],
//       isOnline: data?['isOnline'],
//       lastOnline: data?['last online'],
//       phoneNumber: data?['phone number'],
//     );
//   }
//
//   Map<String, dynamic> toFirestore() {
//     return {
//       if (avatar != null) "avatar": avatar,
//       if (email != null) "email": email,
//       if (name != null) "name": name,
//       if (role != null) "role": role,
//       if (isOnline != null) "isOnline": isOnline,
//       if (lastOnline != null) "last online": lastOnline,
//       if (phoneNumber != null) "phoneNumber": phoneNumber,
//     };
//   }
// }