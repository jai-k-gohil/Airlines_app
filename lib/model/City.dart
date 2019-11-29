import 'package:cloud_firestore/cloud_firestore.dart';
class City {
    final String cityName,imagePath,discount,monthYear;
    final int oldPrice,newPrice;

    City.fromMap(Map<String, dynamic> map)
    :   assert(map['cityName'] != null),
        assert(map['monthYear'] != null),
        assert(map['discount'] != null),
        assert(map['imagePath'] != null),
        cityName = map['cityName'],
        monthYear = map['monthYear'],
        discount = map['discount'],
        oldPrice = map['oldPrice'],
        newPrice = map['newPrice'],
        imagePath = map['imagePath'];

    City.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data);
}
