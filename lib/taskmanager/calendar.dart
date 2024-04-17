import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final void Function(DateTime)? onDateSelected;

  const CustomDatePicker({
    Key? key,
    this.initialDate,
    this.onDateSelected,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2101),
      helpText: 'Select a date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter valid date',
      fieldLabelText: 'Date',
      fieldHintText: 'Month/Date/Year',
      initialDatePickerMode: DatePickerMode.day,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Primary color
              onPrimary: Colors.white, // Text color on primary background
              surface: Colors.white, // Background color of dialog
              onSurface: Colors.black, // Text color on surface background
            ),
            dialogBackgroundColor:
                Colors.white, // Background color of dialog content
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked; // Update the selected date
      });
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return TextButton(
      onPressed: () => _selectDate(context),
      child: Text(
        _selectedDate == null
            ? 'Select Date'
            : '${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
        style: TextStyle(
          color: Colors.blue[800],
        ),
      ),
    );
  }
}
