import 'dart:convert';
import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:staff/helpers/constants.dart';
import 'package:staff/models/staff.dart';

class MongoDatabase{
  static connect() async{
    var db = await Db.create(MONGO_URI);
    await db.open();
    inspect(db);
    var collection = db.collection(COLLECTION_NAME);
  }
  static insert(Staff staff) async{
    var db = await Db.create(MONGO_URI);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);
    //GridFS bucket = GridFS(db,"image");
    await collection.insert({
      "name": staff.name,
      "age": staff.age,
      "phone": staff.phone,
      "department": staff.department,
      "image": staff.image
    });
  }
  static Future<List<Staff>> getAllMembers()async{
    List<Staff> staff=[];
    var db = await Db.create(MONGO_URI);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);
    await collection.find().forEach((v) {
      staff.add(
          Staff(
              name: v['name'],
              age: v['age'],
              phone: v['phone'],
              image: v['image'],
              department: v['department']
          )
      );
    });

    return staff;
  }
  static insertImage(String id,String imgg) async{
    var db = await Db.create(MONGO_URI);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);
    GridFS bucket = GridFS(db,"image");
    Map<String,dynamic> image = {
      "_id" : id,
      "data": imgg
    };
    var res = await bucket.chunks.insert(image);
    var img = await bucket.chunks.findOne({
      "_id": id
    });
    return img;
  }
}