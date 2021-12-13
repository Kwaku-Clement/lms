import 'package:cloud_firestore/cloud_firestore.dart';

class Model {
  String id;
  String createdBy;
  String details;
  String title;
  String imageUrl;
  //DateTime createdAt;
  String date;
  String time;

  Model({
    this.id,
    this.imageUrl,
    this.createdBy,
    this.date,
    this.time,
    this.title,
    this.details,
    // this.createdAt,
  });

  Model.fromSnapshot({DocumentSnapshot doc}) {
    id = doc.id;
    createdBy = doc.get("createdBy");
    time = doc.get("time");
    date = doc.get("date");
    details = doc.get('details');
    imageUrl = doc.get("imageUrl");
    title = doc.get("title");
    //createdAt = doc.get('createdAt');
  }
  Model.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    createdBy = data['createdBy'];
    date = data['date'];
    time = data['time'];
    details = data['details'];
    title = data['title'];
    imageUrl = data['imageUrl'];
    //createdAt = data['createdAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'details': details,
      'title': title,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'date': date,
      'time': time,
      //'createdAt': createdAt,
    };
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';

// class Model {
//   String id;
//   String createdBy;
//   String details;
//   String title;
//   String imageUrl;
//   DateTime createdAt;
//   String date;
//   String time;
//   DocumentReference reference;

//   Model({
//     this.id,
//     this.imageUrl,
//     this.createdBy,
//     this.date,
//     this.time,
//     this.title,
//     this.details,
//     this.createdAt,
//   });

//   factory Model.fromSnapshot(DocumentSnapshot snapshot) {
//     Model newQuiz = Model.fromJson(snapshot.data());
//     newQuiz.reference = snapshot.reference;
//     return newQuiz;
//   }

//   factory Model.fromJson(Map<String, dynamic> json) => _fromMap(json);
//   Map<String, dynamic> toMap() => _toMap(this);

//   @override
//   String toString() => "Model<$title>";
// }

// Model _fromMap(Map<dynamic, dynamic> json) {
//   return Model(
//     imageUrl: json['imageUrl'] as String,
//     details: json['details'] as String,
//     title: json['title'] as String,
//     date: json['date'] as String,
//     time: json['time'] as String,
//     createdAt: json['createdAt'] == null
//         ? null
//         : (json['createdAt'] as Timestamp).toDate(),
//     createdBy: json['createdBy'] as String,
//     id: json['id'] as String,
//   );
// }

// Map<String, dynamic> _toMap(Model instance) => <String, dynamic>{
//       'createdAt': instance.createdAt,
//       'date': instance.date,
//       'time': instance.time,
//       'imageUrl': instance.imageUrl,
//       'details': instance.details,
//       'title': instance.title,
//       'createdBy': instance.createdBy,
//       'id': instance.id,
//     };
  
//   Model.fromDocumentSnapshot({DocumentSnapshot doc}) {
//     id = doc.id;
//     createdBy = doc.get("createdBy");
//     date = doc.get("date");
//     details = doc.get('details');
//     imageUrl = doc.get("imageUrl");
//     title = doc.get("title");
//     createdAt = doc.get('createdAt');
//   }
//   Model.fromMap(Map<String, dynamic> data) {
//     id = data['id'];
//     createdBy = data['createdBy'];
//     date = data['date'];
//     details = data['details'];
//     title = data['title'];
//     imageUrl = data['imageUrl'];
//     createdAt = data['createdAt'];
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'details': details,
//       'title': title,
//       'imageUrl': imageUrl,
//       'createdBy': createdBy,
//       'date': date,
//       'createdAt': createdAt,
//     };
//   }
// }
