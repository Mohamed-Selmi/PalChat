import 'package:flutter/material.dart';
import 'package:pfeapp/API/managegroupAPI.dart';

class AddUserWidget extends StatefulWidget {
    final int groupId;
  const AddUserWidget({required this.groupId, Key? key}) : super(key: key);
  @override
  State<AddUserWidget> createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends State<AddUserWidget> {
   TextEditingController emailController = TextEditingController();

    @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
        title: const Text('Add Member '),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffd1dff6),
      body : Container(
        child:Center(
          child: Column(
            children: [
              const SizedBox(height: 250,),
              SizedBox(height: 40,width:300,
                        child:TextField(
                       
                        enableSuggestions: true,
                        autocorrect: false,
                        controller: emailController,
                        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                          hintText: 'Enter email ',
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
                    ManageGroupAPI.addMemberToGroup(
                      widget.groupId,
                      emailController.text,
                    );
                  },
                  child:const Text("Add",
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
          ],),
        )
      ),
    );
  }
}