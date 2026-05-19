import 'package:flutter/material.dart';
import 'package:pfeapp/API/managegroupAPI.dart';
import 'package:pfeapp/Mainpage/groups.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xfff2f2f2),
       appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: const Text('Create a new group chat'),
      ),
      body : SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                    height:MediaQuery.of(context).size.height * 0.5,
                      child: SvgPicture.asset(
                        'assets/images/group_chat.svg',
                         placeholderBuilder: (BuildContext context) {
      // Placeholder widget while the image is loading
      return CircularProgressIndicator();
    },
                      ),
                    ), 
                                
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,width:MediaQuery.of(context).size.width * 0.8,
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
                          fillColor: Color(0xfff5e1da),
                          border:  OutlineInputBorder(                       
                          ),
                        ),
                      ),
                      ),
                         SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
                           SizedBox(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width:MediaQuery.of(context).size.width * 0.5,
                       child:ElevatedButton(
                        style:ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffe28413)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,)
                              ),
                        ),
                        onPressed: () {
                    ManageGroupAPI.CreateGroup(
                      GroupnameController.text,                    
                    );
                    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserConversations()),
            );
                  },
                  child:const Text("Create",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                     fontFamily: 'Montserrat', 
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    color:  Color(0xff011c27)
                  ),
                  ),
            ),
                      ),
                      SizedBox(height:MediaQuery.of(context).size.height * 0.02,),
                           SizedBox(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width:MediaQuery.of(context).size.width * 0.5,
                       child:ElevatedButton(
                        style:ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffe28413)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,)
                              ),
                        ),
                        onPressed: () {
                    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserConversations()),
            );
                  },
                  child:const Text("Cancel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                     fontFamily: 'Montserrat', 
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    color:  Color(0xff011c27)
                  ),
                  ),
            ),
                      ),
          
          
          
          
          ],),
        ),
      ),
    );
  }
}