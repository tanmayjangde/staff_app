import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staff/helpers/mongo.dart';
import 'package:staff/models/staff.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final items = [
    'HR',
    'Finance',
    'Housekeeping',
    'Marketing'
  ];

  String dropdownvalue = 'HR';

  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  File? img;
  String finalImage='';
  final _formKey = GlobalKey<FormState>();

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);


      if(image == null) return;
      // var _cmpressed_image;
      // try {
      //   _cmpressed_image = await FlutterImageCompress.compressWithFile(
      //       image.path,
      //       format: CompressFormat.heic,
      //       quality: 70
      //   );
      // } catch (e) {
      //   _cmpressed_image = await FlutterImageCompress.compressWithFile(
      //       image.path,
      //       format: CompressFormat.jpeg,
      //       quality: 70
      //   );
      // }
      var i = await image.readAsBytes();
      finalImage = base64Encode(i);
      //finalImage = base64Encode(_cmpressed_image);

      final imageTemp = File(image.path);

      setState(() => img = imageTemp);
    } on PlatformException catch(e) {
      debugPrint('Failed to pick image: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text('Name: ',style: TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
                hintText: 'Enter Name',
              ),
            ),
            const SizedBox(height: 15),
            const Text('Phone: ',style: TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _phone,
              validator: (value) {
                if (value == null || value.isEmpty || value.length<10) {
                  return 'Please enter 10 digit mobile number';
                }
                return null;
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
                hintText: 'Enter Phone',
              ),
            ),
            const SizedBox(height: 15),
            const Text('Age: ',style: TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _age,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  print('xxuuoiuha');
                  return 'Please enter age';
                }
                return null;
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
                hintText: 'Enter Age',
              ),
            ),
            const SizedBox(height: 15),
            const Text('Department: ',style: TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            DropdownButton(
              value: dropdownvalue,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
            const SizedBox(height: 15),
            const Text('Image: ',style: TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            MaterialButton(
                color: Colors.blue,
                child: const Text(
                    "Pick Image from Gallery",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold
                    )
                ),
                onPressed: () {
                  pickImage();
                }
            ),
            img != null ? Image.file(img!): const Center(child: Text("No image selected")),
            const SizedBox(height: 15),
            Center(
              child: MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if(img==null){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('select an image')),
                        );
                      }else{
                        _formKey.currentState!.save();
                        Staff staff = Staff(
                            name: _name.text,
                            age: int.parse(_age.text),
                            phone: _phone.text,
                            department: dropdownvalue,
                            image: finalImage
                        );
                        MongoDatabase.insert(staff);
                        setState(() {
                          _name.text='';
                          _age.text='';
                          _phone.text='';
                          finalImage='';
                          img=null;
                          dropdownvalue='HR';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Uploaded')),
                        );
                      }
                    }
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}