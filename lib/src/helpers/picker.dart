import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

Future<DateTime> selectedDate(BuildContext context, {initialDate}) async =>
    showDatePicker(
      context: context,
      initialDate: initialDate == null ? DateTime.now() : initialDate,
      firstDate: DateTime.now(),
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
      initialTime:
          initialTime == null ? TimeOfDay(hour: 10, minute: 47) : initialTime,
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

Future<DateTime> showAlaramDialog(BuildContext context, {initialDate}) async {
  DateTime datetime = await selectedDate(context, initialDate: initialDate);
  if (datetime == null) {
    return null;
  }
  var time = await selectedTime24Hour(context,
      initialTime: TimeOfDay.fromDateTime(initialDate));
  if (time == null) {
    return null;
  }
  DateTime newDatetime = datetime
      .add(Duration(hours: time.hour, minutes: time.minute, seconds: 0));
  return newDatetime;
}
