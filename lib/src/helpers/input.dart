import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as prefix0;

class InputContainer extends StatelessWidget {
  final ctrl;
  final maxline;
  final placeholder;
  final color;
  final fontSize;
  final hightFromScreen;
  final type;

  final listItem;
  final listItemAdd;
  final listItemRemove;
  final listItemChange;
  const InputContainer({
    this.ctrl,
    this.maxline = 1,
    this.placeholder = " Text",
    this.color = Colors.amber,
    this.fontSize = 16.0,
    this.hightFromScreen,
    this.type = 'text',
    this.listItem,
    this.listItemAdd,
    this.listItemChange,
    this.listItemRemove,
  });

  Widget _typeText(context) {
    return TextField(
      controller: ctrl,
      style: TextStyle(fontSize: fontSize),
      maxLines: maxline,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: placeholder,
          contentPadding:
              EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),
    );
  }

  Widget _typeList(context) {
    return Container(
      padding: EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: 50.0,
              ),
              Container(
                alignment: Alignment.center,
                width: 50.0,
                child: IconButton(
                  icon: Icon(Icons.add),
                  tooltip: 'Tambah',
                  onPressed: listItemAdd,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  child: Text("Tambah"),
                  onTap: listItemAdd,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: listItem.length,
              itemBuilder: (BuildContext context, int i) =>_typeListItem(context, listItem[i], i),
            ),
          )
        ],
      ),
    );
  }

  Widget _typeListItem(context, data, i) {
    TextEditingController controller = TextEditingController(
      text: data.content != null?data.content:''
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          width: 50.0,
          child: IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Pindah',
            onPressed: () {},
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: 50.0,
          child: Checkbox(
            value: listItem[i].isChecked == 1?true:false,
            onChanged: (bool val) {
                listItemChange('isChecked',i,val);
            },
          ),
        ),
        Expanded(
            flex: 2,
            child: TextField(
              controller: controller,
              maxLines: null,
              onChanged: (val){
                listItemChange('content',i,val);
              },
              decoration: InputDecoration(
                
              ),
              style: TextStyle(
                      decoration: listItem[i].isChecked == 1?TextDecoration.lineThrough:TextDecoration.none
                    ),
            )),
        Container(
          alignment: Alignment.center,
          width: 50.0,
          child: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Pindah',
            onPressed: () {
              listItemRemove(i);
            },
          ),
        ),
      ],
    );
  }

  _getchildWidget(context) {
    if (type == 'text') {
      return _typeText(context);
    }
    if (type == 'list') {
      return _typeList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: color),
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 1.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                1.0, // horizontal, move right 10
                1.0, // vertical, move down 10
              ),
            )
          ],
        ),
        margin: EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 5),
        height: hightFromScreen == null
            ? fontSize + 15
            : MediaQuery.of(context).size.height / hightFromScreen, // / 1.5,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 5.0),
        child: _getchildWidget(context));
  }
}

class InputHead extends StatelessWidget {
  final colorCtrl;
  final alrmCtrl;
  final datePost;
  final setAlarm;
  final dialogAlarm;
  const InputHead(
      {this.datePost = '',
      this.colorCtrl,
      this.setAlarm = 0,
      this.alrmCtrl = '',
      this.dialogAlarm});

  Widget _getAlaramBox() {
    if (setAlarm == 0) {
      return Text(" ");
    }
    return FlatButton.icon(
        color: Colors.white,
        // textColor: _colorCtrl,
        icon: Icon(Icons.alarm), //`Icon` to display
        label: Text(prefix0.DateFormat("kk:mm, dd MMM yy  ").format(alrmCtrl)),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: colorCtrl)), //`Text` to display
        onPressed: () {
          dialogAlarm();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(datePost),
          Container(
            child: _getAlaramBox(),
          ),
        ],
      ),
    );
  }
}
/*
class InputHeaderWidget extends StatelessWidget {
  final _ctrl;
  final _placeholder;
  const InputHeaderWidget(this._ctrl, this._placeholder);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      child: TextField(
        controller: _ctrl,
        style: new TextStyle(color: Colors.black, fontSize: 20),
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            border: InputBorder.none,
            // contentPadding: EdgeInsets.only(left: 16, right: 16),
            hintText: _placeholder == null ? 'Text' : _placeholder,
            hintStyle: TextStyle(color: Colors.grey[300])),
      ),
    );
  }
}

class InputFullBodyWidget extends StatelessWidget {
  final _ctrl;
  final _placeholder;
  const InputFullBodyWidget(this._ctrl, this._placeholder);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      TextSpan text = new TextSpan(
        text: _ctrl.text,
      );

      TextPainter tp = new TextPainter(
        text: text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
      );
      tp.layout(maxWidth: size.maxWidth);
      int lines = (tp.size.height / tp.preferredLineHeight).ceil();
      int maxLines = 6;
      return TextField(
        controller: _ctrl,
        maxLines: lines > maxLines ? null : maxLines,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
            hintText: _placeholder,
            contentPadding: EdgeInsets.all(16),
            // border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.teal)),
            // labelText: 'Life story',
            border: InputBorder.none),
      );
    });
  }
}
*/