import 'package:flutter/material.dart';
import 'package:flight_tickets/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flight_tickets/screens/flight_list_screen.dart';
import 'package:flight_tickets/theme.dart';
import 'package:flight_tickets/components/CustomAppBar.dart';
import 'package:flight_tickets/components/CustomShapeClipper.dart';
import 'package:flight_tickets/components/CustomChoiceChip.dart';
import 'package:flight_tickets/components/CityCard.dart';
import 'package:flight_tickets/model/City.dart';
import 'package:flight_tickets/model/Location.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomAppBar(),
        body:SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    children: <Widget>[
                        HomeScreenTopPart(),
                        HomeScreenBottomPart,
                        HomeScreenBottomPart,
                ],
            ),
        ),
    );
  }
}


class HomeScreenTopPart extends StatefulWidget {
  @override
  HomeScreenTopPartState createState() => HomeScreenTopPartState();
}

class HomeScreenTopPartState extends State<HomeScreenTopPart> {
    //List<String> locations = ['Boston (BOS)', 'New York City (NYC)']; for testing
    List<String> locations = List();
    bool isFlightSelected = true;
    bool initialLoad = true;
    var selectedLocationIndex = 0;     
    final _searchFieldController = TextEditingController();
    @override
    Widget build(BuildContext context) {
        return Stack(
            children: <Widget>[
                ClipPath(
                    clipper: CustomShapeClipper(),
                    child: Container(
                        height: 400.0,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [firstColor,secondColor],
                            )
                        ),
                        child: Column(
                            children: <Widget>[
                                SizedBox(height: 50.0),
                                StreamBuilder(
                                  stream: Firestore.instance.collection('locations').snapshots(),
                                  builder: (context, snapshot) {
                                      if (snapshot.hasData && initialLoad) {
                                        addLocations(context,snapshot.data.documents);
                                        initialLoad = false;
                                      }
                                        return !snapshot.hasData ? 
                                        Container() :
                                        Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                                children: <Widget>[
                                                    Icon(Icons.location_on,color: Colors.white,),
                                                    SizedBox(width: 16.0),
                                                    PopupMenuButton(
                                                        onSelected: (int index) {
                                                            setState(() {
                                                                selectedLocationIndex = index;
                                                            });
                                                        },
                                                        child: Row(
                                                            children: <Widget>[
                                                                Text(locations[selectedLocationIndex],style: dropDownLabelStyle),
                                                                Icon(Icons.keyboard_arrow_down,color: Colors.white)
                                                            ],
                                                        ),
                                                        itemBuilder: (BuildContext context) => _buildPopupMenuItems()
                                                    ),
                                                    Spacer(),//has a child of expanded type to give spaces in between widgets
                                                    Icon(Icons.settings,color: Colors.white),
                                                ],
                                            ),
                                        );
                                    }
                                ),
                                SizedBox(height: 50.0),
                                Text("Where would\nyou like to go?",style: TextStyle(fontSize: 24.0,color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                                SizedBox(height: 30.0),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                                    child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        child: TextField(
                                            controller: _searchFieldController,
                                            style: dropDownMenuItemStyle,
                                            cursorColor: appTheme.primaryColor,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(horizontal: 32.0,vertical: 13.0),
                                                suffixIcon: Material(
                                                    elevation: 2.0,
                                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                    child: InkWell(
                                                        child: Icon(Icons.search),
                                                        onTap: () {
                                                            Navigator.push(context,MaterialPageRoute(
                                                                builder: (context) =>
                                                                    InheritedFlightListScreen(fromLocation: locations[selectedLocationIndex], toLocation: _searchFieldController.text,child:FlightListScreen())));
                                                        },
                                                    ),
                                                ),
                                            ),
                                        ),
                                    ),
                                ),
                                SizedBox(
                                    height: 20.0,
                                ),
                                Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                        InkWell(
                                            child: CustomChoiceChip(Icons.flight_takeoff, "Flights", isFlightSelected),
                                            onTap: () {
                                                setState(() {
                                                    isFlightSelected = true;
                                                });
                                            },
                                        ),
                                        SizedBox(
                                            width: 20.0,
                                        ),
                                        InkWell(
                                            child: CustomChoiceChip(Icons.hotel, "Hotels", !isFlightSelected),
                                            onTap: () {
                                                setState(() {
                                                    isFlightSelected = false;
                                                });
                                            },
                                        ),
                                    ],
                                )
                            ],
                        ),
                    ),
                ),
            ],
        );
    }

    List<PopupMenuItem<int>> _buildPopupMenuItems() {
        List<PopupMenuItem<int>> popupMenuItems = List();
        for (int i = 0; i < locations.length; i++) {
          popupMenuItems.add(PopupMenuItem(
              child: Text(
                locations[i],
                style: dropDownMenuItemStyle,
              ),
              value: i,
          ));
        }
        return popupMenuItems;
    }
    addLocations(BuildContext context,List<DocumentSnapshot> snapshots) {
        
        for (int i = 0; i < snapshots.length; i++) {
            final Location location = Location.fromSnapshot(snapshots[i]);
            locations.add(location.name);
        }
    }
}

var viewAllBtnStyle  = TextStyle(fontSize: 14.0,color: appTheme.primaryColor);
var HomeScreenBottomPart = Column(
    children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                    Text("Currently watched items",style: dropDownMenuItemStyle),
                    Spacer(),
                    Text("View All(12)",style: viewAllBtnStyle),
                ]
            ),
        ),
        Container(
            height: 250.0,
            child: StreamBuilder(
                stream: Firestore.instance.collection('cities').snapshots(),
                builder: (context, snapshot) {
                    return !snapshot.hasData ? Center(child:CircularProgressIndicator()) : _buildCitiesList(context, snapshot.data.documents);
                },
            )
        ),
    ],
);

/*
Mockup data for testing purpose
List<CityCard> cityCards = [
    CityCard("assets/images/philippines.jpg", "Philippines", "June-20", "45",2250,4299),
    CityCard("assets/images/spain.jpg", "Spain", "Dec-21", "45", 2250, 4299),
    CityCard("assets/images/maldives.jpg", "Maldives", "Dec-20", "45", 2250, 4299),
];*/

Widget _buildCitiesList(BuildContext context,List<DocumentSnapshot> snapshots) {
        return ListView.builder(
            itemCount: snapshots.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
                return CityCard(City.fromSnapshot(snapshots[index]));
            },
        );
    }
/*
For this case PopupMenuButton was more convenient and suitable for this case rather than using DropDropdownButton for achieveing the
look and feel!!
*/