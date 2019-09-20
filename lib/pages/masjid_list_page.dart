import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearest_masjid/entities/masjid.dart';
import 'package:nearest_masjid/pages/masjid_details_page.dart';
import 'package:nearest_masjid/utils/common_utils.dart';
import 'package:nearest_masjid/utils/database_helper.dart';
import 'package:nearest_masjid/utils/location_utils.dart';
import 'package:nearest_masjid/utils/service_utils.dart';

import '../utils/app_localizations.dart';

class MasjidsListPage extends StatefulWidget {
  MasjidsListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MasjidsListPageState createState() => _MasjidsListPageState();
}

class _MasjidsListPageState extends State<MasjidsListPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Masjid> masjidList;
  int count = 0;
  double _latitude;
  double _longitude;
  double _radius;
  LabeledGlobalKey<ScaffoldState> _scaffoldKey;
  bool _showLoadingIndicator = true;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = LabeledGlobalKey<ScaffoldState>("listScaffoldKey");
    _latitude = 29.97162;
    _longitude = 31.11374;
    _radius = 7.0;
    _fetchCurrentLocation();
  }

  void _fetchCurrentLocation() {
    LocationUtils.findCurrentLocation().then((response) async {
      if (response.error != null && response.error.isNotEmpty) {
        showSnackBar(_scaffoldKey, "${response.error}");
        return;
      }
      Position position = response.position;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
      showSnackBar(_scaffoldKey, 'تم إعتماد احداثيات موقعك الحالي');
      await ServiceUtils.fetchResultFromServer(
          databaseHelper, _latitude, _longitude, _radius.round());
    });
  }

  @override
  Widget build(BuildContext context) {
    FutureBuilder bodyBuilder = FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return buildLoadingDataIndicator(
                  'جارى البحث عن المساجد القريبة ..',
                  TextStyle(color: Colors.white));
            default:
              if (snapshot.hasError) {
                return Text("Snapshot Error : ${snapshot.error}");
              } else {
                if (count == 0)
                  return Container(
                      color: Color.fromRGBO(246, 239, 211, 1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: 25.0),
                          Image(
                            image: AssetImage("assets/mosque.png"),
                            width: 96,
                            height: 96,
                          ),
                          SizedBox(height: 10.0),
                          Text('لا توجد مساجد فى هذا النطاق',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(43, 120, 112, 1.0),
                              )),
                        ],
                      ));
                return Container(
                  color: Color.fromRGBO(246, 239, 211, 1.0),
                  child: ListView.separated(
                    itemBuilder: (context, position) =>
                        _createListViewItem(context, masjidList[position]),
                    itemCount: masjidList.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 8.0,
                      );
                    },
                  ),
                );
              }
          }
        },
        future: databaseHelper.initializeDatabase().then((database) {
          databaseHelper.getMasjidList().then((masjidList) {
            this.masjidList = masjidList;
            this.count = masjidList.length;
            _showLoadingIndicator = false;
          });
        }));
    return Stack(children: <Widget>[
      new Container(
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
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                _fetchCurrentLocation();
              },
            ),
            IconButton(
              icon: Icon(Icons.location_off),
              onPressed: () {
                setState(() {
                  _latitude = 29.97162;
                  _longitude = 31.11374;
                  showSnackBar(_scaffoldKey, 'تم إعتماد الاحداثيات الإفتراضية');
                });
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            _buildSliderDetailBox(),
            Expanded(
              child: bodyBuilder,
            )
          ],
        ),
      )
    ]);
  }


  Widget _createListViewItem(BuildContext context, Masjid masjid) {
    return GestureDetector(
        onTap: () => _onCardTap(masjid),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildMasjidCardViewWidgets(masjid)));
  }

  Widget _buildMasjidCardViewWidgets(Masjid masjid) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 10,
            child: Text(
                masjid.name_ar.isEmpty ? masjid.name_en : masjid.name_ar,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey))),
        Expanded(
            flex: 2,
            child: Text('${masjid.distance.toStringAsFixed(1)}km',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey))),
        Expanded(flex: 2, child: Icon(Icons.chevron_right)),
      ],
    );
  }

  _onCardTap(Masjid masjid) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MasjidDetailPage(masjid)));
  }

  _buildSliderDetailBox() {
    return Row(children: <Widget>[
      Expanded(
        flex: 7,
        child: Container(
          padding: EdgeInsets.all(4.0),
          color: Color.fromRGBO(43, 120, 112, 1.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(
                  '0.5KM',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              Expanded(flex: 7, child: _buildSliderWidget()),
              Expanded(
                  flex: 2,
                  child: Text('10KM',
                      style: TextStyle(fontSize: 14, color: Colors.white)))
            ],
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Container(
            padding: EdgeInsets.all(16.0),
            color: Color.fromRGBO(14, 63, 59, 1.0),
            child: Text('${_radius.round()}KM',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
      )
    ]);
  }

  Slider _buildSliderWidget() {
    return Slider(
      min: 0.5,
      max: 10.0,
      value: _radius,
      inactiveColor: Colors.black26,
      activeColor: Colors.white,
      onChanged: (double newValue) {
        setState(() {
          _radius = newValue;
          print('change on $_radius,$newValue');
        });
        print('change on after setstate $_radius,$newValue');
      },
      onChangeEnd: (double newRadius) {
        print('Ended change on $_radius,$newRadius');
        _onSliderValueChangedEnded(newRadius);
        setState(() {
          _showLoadingIndicator = true;
        });
      },
    );
  }

  _onSliderValueChangedEnded(newRadius) {
    Connectivity().checkConnectivity().then((result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        ServiceUtils.fetchResultFromServer(
            databaseHelper, _latitude, _longitude, newRadius.round())
            .then((response) {
          if (response != null && response) {
            setState(() {
              _showLoadingIndicator = false;
            });
          }
          print(response);
        });
      } else {
        showSnackBar(_scaffoldKey,
            AppLocalization.translate(context, 'no_connection_available'));
      }
    });
  }
}
