import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:staff/models/staff.dart';

class Details extends StatelessWidget{
  final Staff staff;
  const Details({required this.staff, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Staff Member Details",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 25,),
            Center(
              child: ClipOval(
                child: CircleAvatar(
                    radius: 55.0,
                    backgroundImage: MemoryImage(base64Decode(staff.image)),
                    backgroundColor: Colors.transparent
                ),
              ),
            ),
            const SizedBox(height: 15,),
            Text(
                staff.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                fontSize: 25
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Age: ${staff.age}',
              style: const TextStyle(
                  fontSize: 25
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Mobile: ${staff.phone}',
              style: const TextStyle(
                  fontSize: 25
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Department: ${staff.department}',
              style: const TextStyle(
                  fontSize: 25
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}