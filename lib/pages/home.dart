import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import '../schema.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var tController1 = TextEditingController();
  var tController2 = TextEditingController();
  var tController3 = TextEditingController();
  var url="http://10.106.206.0:5000";

  static const _iconTypes = <IconData>[
    Icons.add,
    FontAwesomeIcons.rotate,
    Icons.delete,
    FontAwesomeIcons.eye,
    FontAwesomeIcons.solidEye,
  ];
  // Map<IconData,Function> iconMap={
  //   Icons.add:
  // }
  int curIcon=0;
  int decider=1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Profile',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(32.0,32.0,32.0,0.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Reg No.",
                  ),
                  keyboardType: TextInputType.number,
                  controller: tController1,
                  validator: (String? value) {
                    if ( (value == null || value.isEmpty) &&curIcon%5!=4) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(32.0,32.0,32.0,0.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                  controller: tController2,
                  validator: (String? value) {
                    if ( (value == null || value.isEmpty) &&(curIcon%5!=4&&curIcon%5!=3&&curIcon%5!=2)) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.all(32.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Marks",
                  ),
                  keyboardType: TextInputType.number,
                  controller: tController3,
                  validator: (String? value) {
                    if ( (value == null || value.isEmpty) &&(curIcon%5!=4&&curIcon%5!=3&&curIcon%5!=2)){
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                child: FloatingActionButton(
                  backgroundColor: Colors.indigo,
                  child: AnimatedSwitcher(
                      duration: const Duration(seconds: 2),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        _iconTypes[curIcon%5],
                      )
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                      int opt=curIcon%5;
                      switch(opt){
                        case 0: {
                          addData();
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  "Insertion Done"
                                ),
                                content: const Text(
                                  "The record has been inserted"
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              )
                          );
                        }
                        break;
                        case 1: {
                          updateData();
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                    "Updating Done"
                                ),
                                content: const Text(
                                    "The record has been updated"
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                          );
                        }
                        break;
                        case 2: {
                          deleteData();
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                    "Record Deleted"
                                ),
                                content: const Text(
                                    "The record has been deleted"
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                          );
                        }
                        break;
                        case 3: {
                          //viewOne();
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                  "All the records in the DB"
                              ),
                              content: FutureBuilder<Map<dynamic,dynamic>?>(
                                future: viewData(),
                                builder: (context,snapshot){
                                  if(snapshot.hasError){
                                    print("COD GOD!");
                                  }
                                  else if(snapshot.connectionState==ConnectionState.waiting){
                                    return const CircularProgressIndicator();
                                  }
                                  else if(snapshot.hasData){
                                    final Map<dynamic,dynamic>? viewOne = snapshot.data;
                                    return Container(
                                      height: 300.0,
                                      width: 300.0,
                                      child: Text("Reg No.: ${viewOne?["reg_no"]} Name: ${viewOne?["name"]} Marks: ${viewOne?["marks"]}"),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),

                          );
                        }
                        break;
                        case 4: {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  "All the records in the DB"
                                ),
                                content: FutureBuilder<List<dynamic>?>(
                                  future: viewAllData(),
                                  builder: (context,snapshot){
                                    if(snapshot.hasError){
                                      print("Mangathada Mariyatha");
                                    }
                                    else if(snapshot.connectionState==ConnectionState.waiting){
                                      return const CircularProgressIndicator();
                                    }
                                    else if(snapshot.hasData){
                                      final List<dynamic>? ViewData=snapshot.data;
                                      return Container(
                                        height: 300.0,
                                        width: 300.0,
                                        child: ListView.builder(
                                          itemCount: ViewData?.length,
                                          itemBuilder: (BuildContext context,int index){
                                            return Text("Reg No.: ${ViewData?[index]["reg_no"]} Name: ${ViewData?[index]["name"]} Marks: ${ViewData?[index]["marks"]}");
                                          },
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                          );
                        }
                        break;
                      }
                      setState(() {});
                    }
                  },
                ),
                onHorizontalDragStart: (d){},
                onHorizontalDragUpdate: (d){
                  setState(() {
                    int matter= (d.primaryDelta!).toInt();
                    decider=(matter>=0)?(1):(-1);
                  });

                },
                onHorizontalDragEnd: (details){
                  setState(() {
                    curIcon+=decider;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Future<List> viewAllData() async {
    Response response = await get(Uri.parse("${url}/view_all"));
    Map data=json.decode(response.body);
    List datal=data['result'];
    return datal;
  }
  Future<void> addData() async{
    Student s1=Student(regno: tController1.text,name: tController2.text,marks: tController3.text);
    final response = await post(
      Uri.parse('${url}/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'reg_no': s1.regno,
        'name': s1.name,
        'marks': s1.marks,
      });
  }
  Future<Map<dynamic,dynamic>> viewData() async{
    Response response = await get(
      Uri.parse("${url}/view"),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'reg_no': tController1.text,
      });
    Map data=json.decode(response.body);
    Map datal=data['result'];
    return datal;
  }
  Future<void> updateData() async{
    Student s1=Student(regno: tController1.text,name: tController2.text,marks: tController3.text);
    Response response= await patch(
      Uri.parse("${url}/update"),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'reg_no': s1.regno,
        'name': s1.name,
        'marks': s1.marks,
      });
  }
  Future<void> deleteData() async{
    Student s1=Student(regno: tController1.text,name: tController2.text,marks: tController3.text);
    Response response= await delete(
        Uri.parse("${url}/delete"),
        headers: <String,String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'reg_no': s1.regno,
        });
  }

}
