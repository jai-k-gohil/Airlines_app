import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:airlines_app/theme.dart';
import 'package:airlines_app/main.dart';
import 'package:airlines_app/components/CustomShapeClipper.dart';
import 'package:airlines_app/model/FlightDetails.dart';

final discountBackgroundColor = Color(0xFFFFE880);
final chipBackgroundColor = Color(0xFFF6F6F6);
final flightBorderColor = Color(0xFFE6E6E6);

class InheritedFlightListScreen extends InheritedWidget {
    final String toLocation, fromLocation;
    InheritedFlightListScreen({this.toLocation, this.fromLocation, Widget child}) : super(child:child);

    @override
    bool updateShouldNotify(InheritedWidget oldWidget) {
        return null;
    } 

    static InheritedFlightListScreen of(BuildContext context) => 
        context.inheritFromWidgetOfExactType(InheritedFlightListScreen);
}

class FlightListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            title: Text("Search Result"),
            centerTitle: true,
            leading: InkWell(
                child: Icon(Icons.arrow_back),
                onTap: () {
                    Navigator.pop(context);
                },
            ),
        ),
        body:   SingleChildScrollView(
                    child: Column(
                    children: <Widget>[
                        FlightListTopPart(),
                        SizedBox(height: 20.0),
                        FlightListBottomPart(),
                    ],
                ),
            ),
    );
  }
}

class FlightListBottomPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16.0),
                  child: Text("Best Deals for next 6 months",style: dropDownMenuItemStyle),
                ),
                SizedBox(height: 10.0),
                StreamBuilder(
                    stream: Firestore.instance.collection('deals').snapshots(),
                    builder: (context, snapshot) {
                        return !snapshot.hasData ? Center(child:CircularProgressIndicator()) : _buildDealsList(context, snapshot.data.documents);
                    },
                ),
                /*For testing
                ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                        FlightCard(),
                    ],
                ),*/
            ],
        ),
    );
  }

    Widget _buildDealsList(BuildContext context,List<DocumentSnapshot> snapshots) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshots.length,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
                return FlightCard(flightDetails: FlightDetails.fromSnapshot(snapshots[index]));
            },
        );
    }
}

class FlightCard extends StatelessWidget {
    final FlightDetails flightDetails;
    FlightCard({this.flightDetails});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0),
      child: Stack(
          children: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 16.0),
                  // height: 110.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: flightBorderColor),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                              Row(
                                  children: <Widget>[
                                      Text('${flightDetails.newPrice}',
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)
                                      ),
                                      SizedBox(width: 4.0),
                                      Text('(${flightDetails.oldPrice})',
                                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,decoration: TextDecoration.lineThrough,color: Colors.grey)
                                      ),
                                  ],
                              ),
                              Wrap(
                                  spacing: 8.0,
                                  children: <Widget>[
                                      FlightDetailChip(Icons.calendar_today, flightDetails.date),
                                      FlightDetailChip(Icons.flight_takeoff, flightDetails.airlines),
                                      FlightDetailChip(Icons.star, flightDetails.rating),
                                  ],
                              ),
                          ],
                      ),
                  ),
              ),
              Positioned(
                  top: 10.0,
                  right: 0.0,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
                      child: Text("${flightDetails.discount}%",style: TextStyle(
                              color: appTheme.primaryColor,
                              fontSize: 14.0,
                      )),
                      decoration: BoxDecoration(
                          color: discountBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                  ),
              )
          ],
      ),
    );
  }
}

class FlightDetailChip extends StatelessWidget {
  final IconData iconData;
  final String label;

  FlightDetailChip(this.iconData,this.label);

  @override
  Widget build(BuildContext context) {
    return RawChip(
        label: Text(label),
        labelStyle: TextStyle(color: Colors.black,fontSize: 14.0),
        backgroundColor: chipBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        avatar: Icon(iconData,size: 14.0),
    );
  }
}


class FlightListTopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
            ClipPath(
                clipper: CustomShapeClipper(),
                child: Container(
                    height: 160.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [firstColor,secondColor]
                        )
                    ),
                ),
            ),
            Column(
                children: <Widget>[
                    SizedBox(height: 20.0),
                    Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    elevation: 10.0,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal:16.0,vertical: 22.0),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    Expanded(
                                        flex: 5,
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                                Text(InheritedFlightListScreen.of(context).fromLocation,style: TextStyle(fontSize:16.0 )),
                                                Divider(color: Colors.grey),
                                                Text(InheritedFlightListScreen.of(context).toLocation,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0)),
                                            ],
                                        ),
                                    ),
                                    Spacer(),
                                    Expanded(child:Icon(Icons.import_export,color: Colors.black,size: 32.0),flex: 1,),
                                ],
                            ),
                        ),
                    ),
                ],
            )
        ],
    );
  }
}