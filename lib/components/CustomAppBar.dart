import 'package:flutter/material.dart';
import 'package:flight_tickets/main.dart';
import 'package:flight_tickets/theme.dart';

class CustomAppBar extends StatelessWidget{
    final List<BottomNavigationBarItem> navbarItems = [];
    final bottomNavigationItemStyle = TextStyle(color: Colors.black,fontStyle: FontStyle.normal);
    CustomAppBar() {
        navbarItems.add(
            BottomNavigationBarItem(
                activeIcon: Icon(
                    Icons.home,
                    color: appTheme.primaryColor,
                ),
                icon: Icon(Icons.home,color: Colors.black),
                title: Text("Explore",style: bottomNavigationItemStyle)
            ),
        );
        navbarItems.add(
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite,color: Colors.black),
                title: Text("Watchlist",style: bottomNavigationItemStyle)
            ),
        );
        navbarItems.add(
            BottomNavigationBarItem(
                icon: Icon(Icons.local_offer,color: Colors.black),
                title: Text("Deals",style: bottomNavigationItemStyle)
            ),
        );
        navbarItems.add(
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications,color: Colors.black),
                title: Text("Notifications",style: bottomNavigationItemStyle)
            ),
        );
    }

  @override
  Widget build(BuildContext context) {
    return  Material(
                elevation: 15.0,
                child: BottomNavigationBar(
                items: navbarItems,
                type: BottomNavigationBarType.fixed,
            ),
        );
  }
  
}