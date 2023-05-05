import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



Future<String> fetchImages() async {
  final response = await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['message'];
  } else {
    throw Exception('Unexpected error occured!');
  }
}


class HomePage extends StatefulWidget{
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user;
  int redcounter=0, bluecounter=0, blackcounter=0 ;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }


  //Loading counter value on start
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      redcounter = (prefs.getInt('red') ?? 0);
      bluecounter = (prefs.getInt('blue') ?? 0);
      blackcounter = (prefs.getInt('black') ?? 0);
    });
  }

  //Incrementing counter after click
  Future<void> _incrementCounter(int counter) async {
    final prefs = await SharedPreferences.getInstance();
      switch(counter){
        case 0:{
          setState(() {
            redcounter = (prefs.getInt('red') ?? 0) + 1;
            prefs.setInt('red', redcounter);
          });
          break;
        }
        case 1:{
          setState(() {
            bluecounter = (prefs.getInt('blue') ?? 0) + 1;
            prefs.setInt('blue', bluecounter);
          });
          break;
        }
        case 2:{
          setState(() {
            blackcounter = (prefs.getInt('black') ?? 0) + 1;
            prefs.setInt('black', blackcounter);
          });
          break;
        }
      }

  }


  Future<User?> checkCurrentUser() async {
    try {
      user =  _firebaseAuth.currentUser;
      return user;
    }catch(e){
      print(e);
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AMY"),
      ),
      body:  FutureBuilder<String>(
        future: fetchImages(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: new Icon(Icons.favorite),
                            color: Colors.red,
                            onPressed: (){

                            },
                          ),
                          new Text('$redcounter')
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: new Icon(Icons.favorite),
                            color: Colors.blue,
                            onPressed: (){

                            },
                          ),
                          new Text('$bluecounter')
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: new Icon(Icons.favorite),
                            color: Colors.black,
                            onPressed: (){

                            },
                          ),
                          new Text('$blackcounter')
                        ],
                      ),

                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  Center(
                    child: GestureDetector(
                      child: Image.network(snapshot.data!),
                      onHorizontalDragEnd: (DragEndDetails details){
                        if (details.primaryVelocity! < 0) {
                             //right swipe
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('right swipe')));
                          _incrementCounter(1);
                          print('$bluecounter');
                          _loadCounter();
                        } else if(details.primaryVelocity! > 0){
                                   //Left Swipe
                             ScaffoldMessenger.of(context)
                                   .showSnackBar(SnackBar(content: Text('left swipe')));
                             _incrementCounter(0);
                             print('$bluecounter');
                             _loadCounter();
                        }
                      },
                      onVerticalDragEnd: (DragEndDetails details){
                        if (details.primaryVelocity! > 0) {
                               // Down Swipe
                           ScaffoldMessenger.of(context)
                                 .showSnackBar(SnackBar(content: Text('down swipe')));
                           _incrementCounter(2);
                           _loadCounter();
                        }
                      }
                    ),
                  ),
                ],
              );
          }else if(snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          // By default show a loading spinner.
          return const CircularProgressIndicator();

        },
      )

    );
  }
}