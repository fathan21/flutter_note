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

Future showAlaramDialog(BuildContext context, {initialDate, setAlaram, alaramType}) async {
  showDialog(

      context: context,
      builder: (_) {
              return MyDialog(
                onSave: (e, alaramType){
                  setAlaram(e, alaramType);
                  Navigator.of(context).pop();
                },
                initialDate: initialDate,
                alaramType: alaramType,
              );
            },
    );
}

class MyDialog extends StatefulWidget {
  MyDialog({
    this.onSave,
    this.initialDate,
    this.alaramType,
  });
  final onSave;
  final initialDate;
  final alaramType;
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  final dayOfName = ["Minggu","Senin","Selasa","Rabu","Kamis","Jum'at","Sabtu"];
  final optionsDate = [
    "Hari ini", "Besok","Minggu depan","Pilih tanggal"
  ];
  final optionsTime = [
    {"label":"Pagi", "waktu":"07:00"},
    {"label":"Siang", "waktu":"13:00"},
    {"label":"Malam", "waktu":"20:00"},
    {"label":"Pilih Jam", "waktu":"Pilih Jam"},
  ];
  final optionsType = [
    {"label":"Sekali", "val":1},
    {"label":"Harian", "val":2},
    {"label":"Mingguan", "val":3},
    {"label":"Bulanan", "val":4},
  ];
  
  bool isEdit = false;
  DateTime initialDate = DateTime.now().add(Duration(hours: 4));
  String initialDateLabel;
  String initialTimeLabel;
  int alaramType;
  static const TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );
   @override
  void initState() {
    super.initState();
    
    alaramType = widget.alaramType == null ?1:widget.alaramType;
    isEdit = widget.initialDate == null ?false:true;
    initialDate = widget.initialDate == null? DateTime.now().add(Duration(hours: 4)): widget.initialDate;
    initialDateLabel = DateFormat("d MMMM").format(initialDate);
    initialTimeLabel = DateFormat("HH : mm").format(initialDate);
    print(alaramType);
    print(widget.alaramType);
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

  Widget getBtnAction(context){
    return Container(
      margin: EdgeInsets.only(top: 20.0,left: 0.0, right: 0.0, bottom: 0.0),
      padding: EdgeInsets.all(0.0),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isEdit?
            SizedBox(
              width: 50.0,
              child: FlatButton(
                onPressed: (){
                  widget.onSave(null, null);
                },
                padding: EdgeInsets.all(0.0),
                child: Text("Hapus"),
              ),
            )
              
            :Text(" "),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Batal"),
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: (){
                      widget.onSave(initialDate, alaramType);
                    },
                    color: ThemeData().primaryColor,
                    child: Text("Simpan",),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future generateDate(context,label) async{
    // "Hari ini", "Besok","Minggu depan","Pilih tanggal"
      switch (label) {
        case "Hari ini":
          setState(() {
            initialDate = DateTime.now().add(Duration(hours: 4));
            initialDateLabel = DateFormat("d MMMM").format(DateTime.now().add(Duration(hours: 4)));
            initialTimeLabel = DateFormat("HH : mm").format(DateTime.now().add(Duration(hours: 4)));
          });

          break;
        case "Besok":
          setState(() {
            initialDate = initialDate.add(Duration(days: 1));
            initialDateLabel = DateFormat("d MMMM").format(initialDate);
            initialTimeLabel = DateFormat("HH : mm").format(initialDate); 
          });
          break;
          case "Minggu depan":
            setState(() {
              initialDate = initialDate.add(Duration(days: 7));
              initialDateLabel = DateFormat("d MMMM").format(initialDate);
              initialTimeLabel = DateFormat("HH : mm").format(initialDate); 
            });
          break;
        default:
          selectedDate(context, initialDate: initialDate).then((date) => {
            setState(() {
              initialDate = date;
              initialDateLabel = DateFormat("d MMMM").format(date); 
            })
          });
      }
  }

  
  Future generateTime(context,label) async{
    // var newHour = 5;
    // time = time.toLocal();
    // time = new DateTime(time.year, time.month, time.day, newHour, time.minute, time.second, time.millisecond, time.microsecond);

      switch (label) {
        case "Pilih Jam":
          TimeOfDay newTimeP = await selectedTime24Hour(context,initialTime:TimeOfDay.fromDateTime(initialDate));
          
          var time  = initialDate.toLocal();          
          var newTime = new DateTime(time.year, time.month, time.day, newTimeP.hour, newTimeP.minute, time.second, time.millisecond, time.microsecond);
          setState(() {
            initialDate = newTime;
            initialDateLabel = DateFormat("d MMMM").format(initialDate);
            initialTimeLabel = DateFormat("HH : mm").format(initialDate);
          });
          break;
        default:
          var labelDT = label.toString().split(":");
          var min = int.parse(labelDT[1]);
          var hour = int.parse(labelDT[0]);
          var time  = initialDate.toLocal();
          var newTime = new DateTime(time.year, time.month, time.day, hour, min, time.second, time.millisecond, time.microsecond);
          setState(() {
            initialDate = newTime;
            initialDateLabel = DateFormat("d MMMM").format(initialDate);
            initialTimeLabel = DateFormat("HH : mm").format(initialDate);
          });
      }
  }

  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(0.0),
                child: new Text(
                  "Tambah Pengingat Waktu",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              new DropdownButton<String>(
                isExpanded: true,
                hint: new Text(initialDateLabel, style: TextStyle(color: Colors.black),),
                items: optionsDate.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (e) {
                  generateDate(context,e);
                },
              ),
              new DropdownButton<String>(
                isExpanded: true,
                hint: new Text(initialTimeLabel, style: TextStyle(color: Colors.black),),
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
                  generateTime(context, e);
                },
              ),
              new DropdownButton<String>(
                isExpanded: true,
                value: alaramType != null? alaramType.toString():null,
                items: optionsType.map((value) {
                  return new DropdownMenuItem<String>(
                    value: value["val"].toString(),
                    child: new Text(value["label"]),
                  );
                }).toList(),
                onChanged: (e) {
                  setState(() {
                    alaramType = int.parse(e); 
                  });
                },
              ),
              getBtnAction(context),
              
            ],
          ),
        ),
    );
  }
}
