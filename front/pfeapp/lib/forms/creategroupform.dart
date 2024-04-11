import 'package:flutter/material.dart';
import 'package:pfeapp/API/managegroupAPI.dart';

class CreateGroupWidget extends StatefulWidget {
  const CreateGroupWidget({super.key});

  @override
  State<CreateGroupWidget> createState() => _CreateGroupWidgetState();
}

class _CreateGroupWidgetState extends State<CreateGroupWidget> {
   TextEditingController GroupnameController = TextEditingController();

    @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffd1dff6),
      body : Container(
        child:Column(
          children: [
            SizedBox(height: 350,),
            SizedBox(height: 40,width:300,
                      child:TextField(
                     
                      enableSuggestions: true,
                      autocorrect: false,
                      controller: GroupnameController,
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                        hintText: 'Enter group name ',
                        prefixIcon: Icon(Icons.key,
                        color: Colors.black,),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        border:  OutlineInputBorder(                       
                        ),
                      ),
                    ),
                    ),
                         SizedBox(
                      height:30,
                      width:200,
                     child:ElevatedButton(
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffc2d6f6)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,)
                            ),
                      ),
                      onPressed: () {
                  ManageGroupAPI.CreateGroup(
                    GroupnameController.text,
                  );
                },
                child:const Text("Create",
                textAlign: TextAlign.center,
                style: TextStyle(
                   fontFamily: 'Montserrat', 
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  color:  Color(0xff333333)
                ),
                ),
  ),
                    ),




        ],)
      ),
    );
  }
}