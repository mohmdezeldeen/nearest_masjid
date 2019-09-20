import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nearest_masjid/entities/masjid.dart';

class MasjidDetailPage extends StatefulWidget {
  MasjidDetailPage(this.masjid, {Key key}) : super(key: key);
  final Masjid masjid;

  @override
  _MasjidDetailPageState createState() => _MasjidDetailPageState(this.masjid);
}

class _MasjidDetailPageState extends State<MasjidDetailPage> {
  _MasjidDetailPageState(this.currentMasjid);

  Masjid currentMasjid;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text('${currentMasjid.name_ar ?? currentMasjid.name_en}'),
        ),
        body: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          color: Colors.white,
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[_buildMasjidImage(), _buildMasjidDetailsRow()],
            ),
          ),
        ),
      ),
    ]);
  }

  _buildMasjidImage() {
    return Column(children: <Widget>[
      Image(
        image: AssetImage("assets/mosque.png"),
        width: 128,
        height: 128,
      ),
      SizedBox(
        height: 8.0,
      ),
      Text('لا توجد صور للمسجد',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      SizedBox(
        height: 8.0,
      )
    ]);
  }

  _buildMasjidDetailsRow() {
    return Row(children: <Widget>[
      Expanded(
        flex: 7,
        child: Container(
          padding: EdgeInsets.all(8.0),
          color: Color.fromRGBO(43, 120, 112, 1.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 10,
                  child: Text(
                      currentMasjid.name_ar.isEmpty
                          ? currentMasjid.name_en
                          : currentMasjid.name_ar,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
              Expanded(
                  flex: 3,
                  child: Text('${currentMasjid.distance.toStringAsFixed(1)}km',
                      style: TextStyle(fontSize: 12, color: Colors.white)))
            ],
          ),
        ),
      ),
      Expanded(
        flex: 4,
        child: Container(
          padding: EdgeInsets.all(8.0),
          color: Color.fromRGBO(14, 63, 59, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  )),
              Expanded(
                  flex: 2,
                  child: Text('الاتجاهات',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
            ],
          ),
        ),
      )
    ]);
  }
}
