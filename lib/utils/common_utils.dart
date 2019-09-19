import 'package:flutter/material.dart';

showSnackBar(var key, String content, [SnackBarBehavior behavior]) {
  print('showSnackBar');
  final snackBar = SnackBar(
    content: Text(content),
    behavior: behavior ?? SnackBarBehavior.fixed,
  );
  if (key.currentState != null) key.currentState.showSnackBar(snackBar);
}

Column buildLoadingDataIndicator(String text) {
  return Column(children: <Widget>[
    Center(
        child: Container(
            padding: EdgeInsetsDirectional.only(top: 150.0),
            alignment: Alignment.center,
            child: CircularProgressIndicator())),
    SizedBox(height: 25.0),
    Text(text)
  ]);
}