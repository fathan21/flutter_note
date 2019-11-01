import 'dart:async' show Future;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_f/src/ui/form_list.dart';
import 'package:note_f/src/ui/form_text.dart';

Future<T> _showAlert<T>({BuildContext context, Widget child}) => showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    );

Future<bool> showAlert(BuildContext context,{String title,String negativeText = "Cancel",String positiveText = "Confirm",bool onlyPositive = false}) =>
    _showAlert<bool>(
      context: context,
      child: CupertinoAlertDialog(title: Text(title),actions: _buildAlertActions(context, onlyPositive, negativeText, positiveText),),
    );

List<Widget> _buildAlertActions(BuildContext context, bool onlyPositive, String negativeText, String positiveText) {
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
            ],
          ),
        );
      },
    );
