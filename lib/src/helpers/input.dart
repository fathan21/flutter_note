import 'package:flutter/material.dart';

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
