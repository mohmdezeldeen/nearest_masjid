import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearest_masjid/entities/masjid.dart';
import 'package:nearest_masjid/pages/masjid_details_page.dart';
import 'package:nearest_masjid/utils/common_utils.dart';
import 'package:nearest_masjid/utils/location_utils.dart';
import 'package:nearest_masjid/utils/service_utils.dart';

class MasjidsListPage extends StatefulWidget {
  MasjidsListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MasjidsListPageState createState() => _MasjidsListPageState();
}

class _MasjidsListPageState extends State<MasjidsListPage> {
  double _latitude;
  double _longitude;
  double _radius;
  List<Masjid> masjidsList = List();
  LabeledGlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = LabeledGlobalKey<ScaffoldState>("detailScaffoldKey");
    _latitude = 29.97162;
    _longitude = 31.11374;
    _radius = 7.0;
//    _completeMissionSendRequest();
  }

  void _completeMissionSendRequest() {
    LocationUtils.findCurrentLocationName().then((response) {
      if (response.error != null && response.error.isNotEmpty) {
        showSnackBar(_scaffoldKey, "${response.error}");
        return;
      }
      Position position = response.position;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

//      currentAttendance.sendToNamaAndSaveToDB().then((map) {
//        List<String> messages = map["messages"];
//        for (String message in messages) {
//          showSnackBar(_scaffoldKey, message);
//        }
//      });
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
                  'جارى البحث عن المساجد القريبة ..');
            default:
              if (snapshot.hasError) {
                return Text("Snapshot Error : ${snapshot.error}");
              } else {
                if (snapshot.data == null)
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.account_balance,
                        size: 96.0,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5.0),
                      Text('لا توجد مساجد فى هذا النطاق',
                          style: TextStyle(
                            fontSize: 32.0,
                            color: Colors.grey,
                          )),
                    ],
                  ));
                return ListView.builder(
                    itemBuilder: (context, position) =>
                        _createListViewItem(context, masjidsList[position]),
                    itemCount: masjidsList.length);
              }
          }
        },
        future: ServiceUtils.fetchResultFromServer(
                _latitude, _longitude, _radius.round())
            .then((response) async {
          if (response != null) {
            this.masjidsList = response.data;
          } else {
            print('ERROR: ${response}');
          }
          return masjidsList.length;
        }));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[_buildSliderRow(), bodyBuilder],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _completeMissionSendRequest,
        child: Icon(Icons.my_location),
      ),
    );
  }

  Widget _createListViewItem(BuildContext context, Masjid masjid) {
    return GestureDetector(
        onTap: () => _onCardTap(masjid),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildMasjidViewWidgets(masjid)),
        )));
  }

  List<Widget> _buildMasjidViewWidgets(Masjid masjid) {
    return <Widget>[
      Text('${masjid.name_ar} ${masjid.distance} '),
    ];
  }

  _onCardTap(Masjid masjid) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MasjidDetailPage(masjid)));
  }

//  Container _buildLoginButton(BuildContext context) {
//    return Container(
//      child: RaisedButton(
//        child: Text(AppLocalization.translate(context, 'btn_login')),
//        onPressed: () {
//          if (_formKey.currentState.validate()) {
//            _formKey.currentState.save();
//            checkInternetConnection();
//          }
//        },
//        color: Colors.deepOrange,
//        textColor: Colors.white,
//        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
//        splashColor: Colors.grey,
//        shape: getCommonButtonShape(),
//      ),
//    );
//  }

  Row _buildSliderRow() {
    return Row(
      children: <Widget>[
        Text('0.5KM'),
        Slider(
          min: 0.5,
          max: 10.0,
          divisions: 10,
          value: _radius,
          onChanged: (double newValue) {
            setState(() {
              _radius = newValue;
            });
          },
          onChangeEnd: (double newValue) {
            print('Ended change on $newValue');
            _radius = newValue;
            _onSliderValueChangedEnded();
          },
        ),
        Text('10KM'),
        SizedBox(width: 5.0),
        Text('${_radius.round()}KM'),
      ],
    );
  }

  _onSliderValueChangedEnded() async {
    ServiceUtils.fetchResultFromServer(_latitude, _longitude, _radius.round())
        .then((response) {
      List<Masjid> data;
      if (response != null)
        data = response.data;
      else
        data = List();
      print(data.length);
    });
  }
}
