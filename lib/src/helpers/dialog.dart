import 'dart:async' show Future;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:note_f/src/ui/example.dart';
import 'package:note_f/src/ui/form_list.dart';
import 'package:note_f/src/ui/form_text.dart';

Future<T> _showAlert<T>({BuildContext context, Widget child}) => showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    );

Future<bool> showAlert(BuildContext context,
        {String title,
        String negativeText = "Cancel",
        String positiveText = "Confirm",
        bool onlyPositive = false}) =>
    _showAlert<bool>(
      context: context,
      child: CupertinoAlertDialog(
        title: Text(title),
        actions: _buildAlertActions(
            context, onlyPositive, negativeText, positiveText),
      ),
    );

List<Widget> _buildAlertActions(BuildContext context, bool onlyPositive,
    String negativeText, String positiveText) {
  if (onlyPositive) {
    return [
      CupertinoDialogAction(
        child: Text(
          positiveText,
          style: TextStyle(fontSize: 18.0),
        ),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
    ];
  } else {
    return [
      CupertinoDialogAction(
        child: Text(
          negativeText,
          style: TextStyle(color: Color(0xFF71747E), fontSize: 18.0),
        ),
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context, false);
        },
      ),
      CupertinoDialogAction(
        child: Text(
          positiveText,
          style: TextStyle(fontSize: 18.0),
        ),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
    ];
  }
}

/*
Future _showLoadingDialog(BuildContext c, LoadingDialog loading,{bool cancelable = true}) =>
        showDialog(context: c,barrierDismissible: cancelable,builder: (BuildContext c) => loading);

/// 加载框
class LoadingDialog extends CupertinoAlertDialog {
  BuildContext parentContext;
  BuildContext currentContext;
  bool showing;
  show(BuildContext context) {
    parentContext = context;
    showing = true;
    _showLoadingDialog(context, this).then((_) {
      showing = false;
    });
  }

  hide() {
    if (showing) {
      Navigator.removeRoute(parentContext, ModalRoute.of(currentContext));
    }
  }

  @override
  Widget build(BuildContext context) {
    currentContext = context;
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: Container(
              width: 120,
              height: 120,
              child: CupertinoPopupSurface(
                child: Semantics(
                  namesRoute: true,
                  scopesRoute: true,
                  explicitChildNodes: true,
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

*/

Future<DateTime> dialogRound(BuildContext context, {initialDate}) async {
  var myColor = Colors.red;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Rate",
                      style: TextStyle(fontSize: 24.0),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.star_border,
                          color: myColor,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: myColor,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: myColor,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: myColor,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: myColor,
                          size: 30.0,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Divider(
                  color: Colors.grey,
                  height: 4.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Add Review",
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: myColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                          bottomRight: Radius.circular(32.0)),
                    ),
                    child: Text(
                      "Rate Product",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Future dialogAddNote(BuildContext c) => showDialog(
      context: c,
      builder: (BuildContext c) {
        // return object of type Dialog
        const styleBtn = TextStyle(fontSize: 20);
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            // verticalDirection: VerticalDirection.down,
            children: <Widget>[
              FlatButton(
                onPressed: () {},
                child: const Text('Tambah Catatan', style: styleBtn),
              ),
              FlatButton.icon(
                icon: Icon(Icons.list), //`Icon` to display
                label: Text(
                  'Text',
                  style: styleBtn,
                ), //`Text` to display
                onPressed: () {
                  Navigator.pop(c, true);
                  Navigator.push(
                    c,
                    MaterialPageRoute(builder: (c) => new FormTextPage(id: 0)),
                  );
                },
              ),
              FlatButton.icon(
                icon: Icon(Icons.check_box), //`Icon` to display
                label: Text(
                  'Daftar Centang',
                  style: styleBtn,
                ), //`Text` to display
                onPressed: () {
                  Navigator.pop(c, true);
                  Navigator.push(
                    c,
                    MaterialPageRoute(builder: (c) => new FormListPage(id: 0)),
                  );
                },
              ),
              // FlatButton.icon(
              //   icon: Icon(Icons.image), //`Icon` to display
              //   label: Text(
              //     'Gambar',
              //     style: styleBtn,
              //   ), //`Text` to display
              //   onPressed: () {
              //     Navigator.pop(c, true);
              //     Navigator.push(
              //       c,
              //       MaterialPageRoute(builder: (c) => new Example()),
              //     );
              //   },
              // ),

            ],
          ),
        );
      },
    );
