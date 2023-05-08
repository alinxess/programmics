import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:programmics/login.dart';
import 'package:programmics/home_page.dart';
import 'package:programmics/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(AuthCheck());
}

class AuthCheck extends StatefulWidget{
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck>{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user;
  String? token;


  @override
  void initState() {

    super.initState();

    checkCurrentUser();
  }

  Future<User?> checkCurrentUser() async {
    try {
      user =  _firebaseAuth.currentUser;
      token = await user!.getIdToken();
      debugPrint('current user : '+ token!);
      return user;
    }catch(e){
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(

        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.black,
        buttonColor: Colors.black,
        primaryIconTheme: IconThemeData(color: Colors.black),
        primaryTextTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black, fontFamily: "Aveny")),
        textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black)),

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<User?>(
        future: checkCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<User?>snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Scaffold(
                body: Container(
                  color: Color.fromARGB(255, 244, 194, 87),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            case ConnectionState.done:
              if(snapshot.data!=null)
              {
                return MyApp(
                    token:token,
                    user:user
                );
              }
              return LoginPage();
          }
          //return null;
        },
      ),
    );
  }
}

class MyApp extends StatefulWidget{
  final User? user;
  final token;
  _MyAppState createState() => _MyAppState();
  MyApp({Key? key,this.user,this.token}) : super(key: key);
}

class _MyAppState extends State<MyApp>{



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(

        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.black,
        buttonColor: Colors.black,
        primaryIconTheme: IconThemeData(color: Colors.black),
        primaryTextTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black, fontFamily: "Aveny")),
        textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black)),

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}