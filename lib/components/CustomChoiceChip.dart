import 'package:flutter/material.dart';

//making own custom widget according to usecase
class CustomChoiceChip extends StatefulWidget {
    IconData icon;
    String text;
    bool isSelected;

    CustomChoiceChip(this.icon,this.text,this.isSelected);

    @override
    _CustomChoiceChipState createState() => _CustomChoiceChipState();
}

class _CustomChoiceChipState extends State<CustomChoiceChip> {
    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 8.0),
            decoration: widget.isSelected ? BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ) : null,
            child: Row(
                mainAxisSize: MainAxisSize.min,//take minimum space as possible
                mainAxisAlignment: MainAxisAlignment.spaceBetween,//for even gap between both buttons
                children: <Widget>[
                    Icon(
                        widget.icon,
                        size: 20.0,
                        color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                        widget.text,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                        ),
                    )
                ],

            ),
        );
    }
}