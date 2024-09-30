import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:to_do_app/models/task_model.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Appointment> _appointments = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: Navigationbar(),
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text(
        "calendar_page_title",
        style: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      ).tr()),
      body: Container(
        child: SfCalendar(
          dataSource: EventDataSource(_appointments),
          onTap: (CalendarTapDetails details) {
            if (details.targetElement == CalendarElement.calendarCell) {
              _showAddAppointmentDialog(details.date!);
            }
          },
          backgroundColor: Colors.white,
          view: CalendarView.month,
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        ),
      ),
    );
  }

  void _showAddAppointmentDialog(DateTime selectedDate) {
    final TextEditingController _eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Yeni Etkinlik Ekle'),
          content: TextField(
            controller: _eventController,
            decoration: InputDecoration(hintText: 'Etkinlik Adı'),
          ),
          actions: [
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ekle'),
              onPressed: () {
                _addAppointment(selectedDate, _eventController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Girilen etkinliği listeye ekliyoruz
  void _addAppointment(DateTime selectedDate, String eventName) {
    setState(() {
      _appointments.add(Appointment(
        startTime: selectedDate,
        endTime: selectedDate.add(Duration(hours: 1)), // 1 saatlik etkinlik
        subject: eventName,
        color: Colors.blue,
      ));
    });
  }
}

// Etkinliklerin kaynağı
class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
