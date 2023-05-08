import 'package:flutter/material.dart';
import 'package:programmics/stack_item.dart';

class StackItem extends StatefulWidget{
  final int? id;
  final String? image;
  StackItem({this.id,this.image});

  _StackItemState createState() => _StackItemState();
}

class _StackItemState extends State<StackItem>{
  bool isPressed = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
        child: Card(
         elevation: widget.id!*4.0 ,
         shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(10.0)),
         ),
          child: ClipRRect(
           borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //alignment: Alignment.center,
            //width: (MediaQuery.of(context).size.width * 0.8) + (widget.id! * 20),
               child: new Image.network(
                widget.image!,
                fit: BoxFit.fill,
                 width: (MediaQuery.of(context).size.width * 0.8) + (widget.id! * 20),
                 height:300,
                 scale: 0.8,
              ),
          ),
    )
    );
  }

}