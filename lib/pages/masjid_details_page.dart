import 'package:flutter/material.dart';
import 'package:nearest_masjid/entities/masjid.dart';

class MasjidDetailPage extends StatefulWidget {
  MasjidDetailPage(this.masjid, {Key key, this.title}) : super(key: key);
  final Masjid masjid;
  final String title;

  @override
  _MasjidDetailPageState createState() => _MasjidDetailPageState(this.masjid);
}

class _MasjidDetailPageState extends State<MasjidDetailPage> {
  _MasjidDetailPageState(this.currentMasjid);

  Masjid currentMasjid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:${currentMasjid.name_ar},${currentMasjid.distance}',
            ),
          ],
        ),
      ),
    );
  }
}
