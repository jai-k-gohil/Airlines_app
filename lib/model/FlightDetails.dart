import 'package:cloud_firestore/cloud_firestore.dart';
class FlightDetails {
    final String airlines,date,discount,rating;
    final int oldPrice,newPrice;

    FlightDetails.fromMap(Map<String, dynamic> map)
    :   assert(map['airlines'] != null),
        assert(map['date'] != null),
        assert(map['discount'] != null),
        assert(map['rating'] != null),
        airlines = map['airlines'],
        date = map['date'],
        discount = map['discount'],
        oldPrice = map['oldPrice'],
        newPrice = map['newPrice'],
        rating = map['rating'];

    FlightDetails.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data);
}