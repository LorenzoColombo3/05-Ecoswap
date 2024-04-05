import 'package:flutter/material.dart';

class DateField extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  const DateField({Key? key, this.onDateSelected}) : super(key: key);
  @override
  _DateFieldState createState() => _DateFieldState();

  static DateTime? getSelectedDate(BuildContext context) {
    final _DateFieldState? state = context.findAncestorStateOfType<_DateFieldState>();
    return state?._selectedDate;
  }
}

class _DateFieldState extends State<DateField> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.onDateSelected?.call(_selectedDate!);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return 
    TextField(
      readOnly: true,
      onTap: () {
        _selectDate(context);
      },
      controller: TextEditingController(
        text: _selectedDate != null ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}' : '',
      ),
      decoration: const InputDecoration(
        labelText: 'Date',
        prefixIcon: Icon(Icons.calendar_today),
      ),
    );
  }

  DateTime? getSelectedDate() {
    return _selectedDate;
  }
  
}