import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:staff/helpers/mongo.dart';
import 'package:staff/models/staff.dart';
import 'package:staff/screens/details.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  bool _isLoading = true;
  List<Staff> members = [];

  @override
  initState(){
    getData();
    super.initState();
  }

  getData()async{
    members = await MongoDatabase.getAllMembers();
    setState(() {
      _isLoading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return _isLoading?
    const Center(child: CircularProgressIndicator()):
    RefreshIndicator(
      onRefresh: ()async {
        await Future.delayed(const Duration(milliseconds: 1500));
        getData();
      },
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            for(int i=0;i<members.length;i++)
            Card(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>Details(staff: members[i]))
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        ClipOval(
                          child: CircleAvatar(
                              radius: 35.0,
                              backgroundImage: MemoryImage(base64Decode(members[i].image)),
                              backgroundColor: Colors.transparent
                          ),
                        ),
                        const SizedBox(width: 25,),
                        Text(members[i].name)
                      ],
                    ),
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}