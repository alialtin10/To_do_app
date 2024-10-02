import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:to_do_app/models/task_model.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDate;
  late List<Task> _allTask;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allTask = <Task>[];
  }

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
      body: SfCalendar(
        view: CalendarView.month,
        firstDayOfWeek: 1,
        allowAppointmentResize: true,
        allowDragAndDrop: true,
        dataSource: EventDataSource(_allTask),
        allowedViews: [
          CalendarView.day,
          CalendarView.month,
        ],
        showNavigationArrow: true,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          showTrailingAndLeadingDates: false,
          //agendaViewHeight: 100,
          navigationDirection: MonthNavigationDirection.horizontal,
        ),
        onTap: (details) {
          setState(() {
            _selectedDate = details.date;
            if (_selectedDate != null) {
              _showEventDialog();
            }
          });
          //_showAddTaskBottomSheet(context);
        },
      ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: "add_task".tr(),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showDatePicker(context, onConfirm: (time) async {
                    var addNewTask = Task.create(name: value, createdAt: time);
                    _allTask.insert(0, addNewTask);
                    setState(() {});
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _showEventDialog() {
    String eventName = '';
    DateTime startDate = _selectedDate ?? DateTime.now();
    DateTime endTime = _selectedDate ?? DateTime.now();
    Color selectedColor = Colors.blue;
    List<Color> Colorss = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.amber,
      Colors.pink,
      Colors.green,
      Colors.red
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("dialog_title").tr(),
          content: Column(
            children: [
              // event Name
              TextField(
                decoration:
                    InputDecoration(labelText: "dialog_event_name".tr()),
                onChanged: (value) {
                  eventName = value;
                },
              ),

              SizedBox(
                height: 10,
              ),

              // Start Time select
              ListTile(
                title: Text("Başlama Tarihi: ${startDate.toLocal()}"),
                trailing: Icon(Icons.calendar_today), // nu ikon değiştir
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != startDate) {
                    setState(() {
                      startDate = picked;
                    });
                  }
                },
              ),

              // End Time select
              ListTile(
                title: Text("Bitiş Tarihi: ${endTime.toLocal()}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: endTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null && picked != endTime) {
                    setState(() {
                      endTime = picked;
                    });
                  }
                },
              ),

              // Renk seçimi
              ListTile(
                title: Text("Etkinlik Rengi"),
                trailing: DropdownButton<Color>(
                  value: selectedColor,
                  items: Colorss.map((Color color) {
                    return DropdownMenuItem<Color>(
                      value: color,
                      child: Container(
                        width: 24,
                        height: 24,
                        color: color,
                      ),
                    );
                  }).toList(),
                  onChanged: (Color? newColor) {
                    setState(() {
                      selectedColor = newColor ?? Colors.blue;
                    });
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("dialog_cancel_buton").tr()),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  var _allNewTask = Task.createCalendarEvents(
                      eventName: eventName,
                      startTime: startDate,
                      endTime: endTime,
                      backgroundColor: selectedColor,
                      isAllDay: true);
                  _allTask.insert(0, _allNewTask);
                  setState(() {});
                },
                child: Text("dialog_add_buton").tr())
          ],
        );
      },
    );
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Task> source) {
    appointments = source;
  }
}
