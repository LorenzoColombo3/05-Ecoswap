import 'package:flutter/material.dart';

class DateField extends StatefulWidget {
  @override
  _DateFieldState createState() => _DateFieldState();
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
  
}