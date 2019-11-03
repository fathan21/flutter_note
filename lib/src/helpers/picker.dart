import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';

Future<DateTime> selectedDate(BuildContext context, {initialDate}) async =>
    showDatePicker(
      context: context,
      initialDate: initialDate == null ? DateTime.now() : initialDate,
      firstDate: initialDate == null || (DateTime.now()).difference(initialDate).inDays <= 0 ? DateTime.now() : initialDate,
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );

Future<TimeOfDay> selectedTime24Hour(BuildContext context,
        {initialTime}) async =>
    showTimePicker(
      context: context,
      initialTime: initialTime == null ? TimeOfDay(hour: 10, minute: 47) : initialTime,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );

Future colorPicker(BuildContext context,
        {currentColor = Colors.blue, changeColor}) async =>
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text('Warna'),
          content: Container(
            height: 200,

            /// MediaQuery.of(context).size.height,
            child: MaterialColorPicker(
                selectedColor: currentColor,
                allowShades: false,
                onMainColorChange: ((color) =>
                    {Navigator.pop(context, color)})),
          ),
        );
      },
    );

Future showAlaramDialog(BuildContext context, {initialDate}) async {
  showDialog(
      context: context,
      builder: (BuildContext context) => new AlaramDialog().show(context)
    );
}

class AlaramDialog {
  final teFirstName = TextEditingController();
  final teLastFirstName = TextEditingController();
  final teDOB = TextEditingController();
  final isEdit = false;

  final dayOfName = ["Minggu","Senin","Selasa","Rabu","Kamis","Jum'at","Sabtu"];
  final optionsDate = [
    "Hari ini", "Besok","Minggu depan","Pilih tanggal"
  ];
  final optionsTime = [
    {"label":"Pagi", "waktu":"07:00"},
    {"label":"Siang", "waktu":"13:00"},
  ];
  final optionsType = [
    "Sekali", "Harian","Mingguan","Bulanan"
  ];
  String initialDateLabel = DateFormat("d MMMM").format(DateTime.now().add(Duration(hours: 4)));
  String initialTimeLabel = DateFormat("HH : mm").format(DateTime.now().add(Duration(hours: 4)));

  static const TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  Widget show(BuildContext context,) {
      var d =  
      new Dialog(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: new Text(
                  "Tambah Pengingat Waktu",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              new DropdownButton<String>(
                isExpanded: true,
                hint: new Text(initialDateLabel),
                items: optionsDate.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (e) {
                  print(e);
                },
              ),
              new DropdownButton<String>(
                isExpanded: true,
                hint: new Text(initialTimeLabel),
                items: optionsTime.map((value) {
                  return new DropdownMenuItem<String>(
                    value: value["waktu"],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(value["label"]),
                        Text(value["waktu"]),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (e) {
                  print(e);
                },
              ),
              new DropdownButton<String>(
                isExpanded: true,
                hint: new Text("Sekali"),
                items: optionsType.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (e) {
                  print(e);
                },
              ),
              getBtnAction(),
              
            ],
          ),
        ),
        
      );
      return d;
  }

  Widget getTextField(
      String inputBoxName, TextEditingController inputBoxController) {
    var loginBtn = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );

    return loginBtn;
  }

  Widget getBtnAction(){
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isEdit?FlatButton(
            onPressed: (){

            },
            child: Text("Hapus"),
          ):Text(" "),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: (){

                  },
                  child: Text("Batal"),
                ),
                FlatButton(
                  onPressed: (){

                  },
                  color: ThemeData().primaryColor,
                  child: Text("Simpan"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

