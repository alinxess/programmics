import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_tindercard_plus/flutter_tindercard_plus.dart';
import 'package:programmics/stack_item.dart';



Future<List<String>> fetchImages() async {
  final response = await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random/5'));
  if (response.statusCode == 200) {
    //return json.decode(response.body)['message'];
    // Use the compute function to run parsePhotos in a separate isolate.
    return compute(parseImages, response.body);
  } else {
    throw Exception('Unexpected error occured!');
  }
}

// A function that converts a response body into a List<Photo>.
List<String> parseImages(String responseBody) {
  return (jsonDecode(responseBody)['message'] as List<dynamic>).cast<String>();
}


class Home extends StatefulWidget{
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user;


  //late Future<List<dynamic>> images, list;
  //late List<Future<dynamic>> list;



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
        body: FutureBuilder<List<String>>(
          future: fetchImages(),
          builder: (context, snapshot){
            //List? items = snapshot.data!;
            //List? list=[];
            if (snapshot.hasData && snapshot.data!.length != 0){
              return ImageStack(imagelist: snapshot.data!);/*Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child:Stack(
                        alignment: Alignment.center,
                        children: items.asMap().entries.map((e) => Positioned(
                            bottom: (e.key)* 10.0,
                            child: GestureDetector(
                              child: StackItem(
                                 id: e.key,
                                 image: e.value,
                              ),
                              onHorizontalDragEnd: (DragEndDetails details){
                               if (details.primaryVelocity! < 0) {
                                 //left swipe
                                 setState(() {
                                   items.removeAt(e.key);
                                 });
                                 ScaffoldMessenger.of(context)
                                     .showSnackBar(SnackBar(content: Text('left swipe')));
                               } else if(details.primaryVelocity! > 0){
                                 //right Swipe
                                 setState(() {
                                   items.removeAt(e.key);
                                 });
                                 //list.add(e.value);
                                 ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text('right swipe')));
                               }
                              },

                            ),
                        )
                        ).toList(),
                      )
                  ),
                  )
                ]
              );*/
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


class ImageStack extends StatefulWidget{
  List<String> imagelist;
  ImageStack({Key? key, required this.imagelist}) : super(key: key);
  _ImageStackState createState() => _ImageStackState();
}

class _ImageStackState extends State<ImageStack> {
  List<String> list=[];

  int counter=1, round=1;
  double offsetX = 0.0;

  @override
  void initState() {
    super.initState();
  }

 void _incrementCounter(){
    setState(() {
      round++;
    });
  }


  @override
  Widget build(BuildContext context) {
    list = widget.imagelist;
    if (list.length!= 1) {
      for (int i = 1; i < list.length; i++) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Round $round',
                  style: TextStyle(
                      fontSize: 30
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom:20.0),
              ),
              Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                 child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Stack(
                      alignment: Alignment.center,
                      children: list
                          .asMap()
                          .entries
                          .map((e) =>
                          Positioned(
                            bottom: (e.key) * 10.0,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  offsetX += details.delta.dx;
                                });
                              },
                              child: Draggable(
                                data: "stack",
                                child: StackItem(
                                  id: e.key,
                                  image: e.value,
                                ),
                                feedback: StackItem(
                                  id: e.key,
                                  image: e.value,
                                ) ,
                                childWhenDragging: Container(),
                                onDragEnd: (drag){
                                  setState(() {
                                    if (drag.velocity.pixelsPerSecond.dx > 0) {
                                      // Swiped right
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(content: Text('right swipe')));
                                      if(i==widget.imagelist.length){
                                        _incrementCounter();
                                      }
                                      list.insert(0, list.removeAt(e.key));
                                    } else if (drag.velocity.pixelsPerSecond.dx < 0) {
                                      // Swiped left
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(content: Text('left swipe')));
                                      list.removeAt(e.key);
                                    }
                                    offsetX = 0.0;
                                  });
                                },
                              ),

                              /*onHorizontalDragEnd: (DragEndDetails details) {
                                if (details.primaryVelocity! < 0) {
                                  //left swipe
                                  setState(() {
                                    list.removeAt(e.key);
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                      SnackBar(content: Text('left swipe')));
                                } else if (details.primaryVelocity! > 0) {
                                  //right Swipe
                                  setState(() {
                                      list.insert(0, list.removeAt(e.key));
                                  });
                                  //list.add(e.value);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                      SnackBar(content: Text('right swipe')));
                                }
                              },*/

                            ),


                          )
                      ).toList(),
                    )
              )
              )
              )
            ]
        );

      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children:<Widget>[
        Text("WINNER IS",
        style: TextStyle(
          fontSize: 30
        )),
        Container(
    margin: EdgeInsets.only(left:20.0),
    child: Card(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    child: ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //alignment: Alignment.center,
    //width: (MediaQuery.of(context).size.width * 0.8) + (widget.id! * 20),
    child: new Image.network(
    list[0],
    fit: BoxFit.fill,
    width: (MediaQuery.of(context).size.width * 0.8) ,
    height:300,
    scale: 0.8,
    ),
    ),
    )
    )
      ]
    );
  }

}