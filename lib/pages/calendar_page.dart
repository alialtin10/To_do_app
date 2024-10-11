import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDate;
    late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
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
        dataSource: EventDataSource(_allTasks),
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
        onLongPress: (details) {
           setState(() {
            _selectedDate = details.date;
            if (_selectedDate != null) {
              _showEventDialog();
            }
          });
        },
        onTap: (details) {
          
        },
      ),
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
                  print(eventName);
                },
              ),

              SizedBox(
                height: 5,
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
                      print(startDate.toString());
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
                      selectedColor = newColor!;
                      print(selectedColor);
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
                onPressed: ()  async {
                  var _allNewTask = Task.createCalendarEvents(
                      eventName: eventName,
                      startTime: startDate,
                      endTime: endTime,
                      backgroundColor: selectedColor,
                      isAllDay: true);
                  _allTasks.insert(0, _allNewTask);
                  await _localStorage.addTask(task: _allNewTask);
                  setState(() {});
                  Navigator.of(context).pop();

                },
                child: Text("dialog_add_buton").tr())
          ],
        );
      },
    );
  }

void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    print(_allTasks.toString());
    setState(() {});
  }

}



class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Task> source) {
    appointments = source;
  }

  @override
  String getId(int index){
    return appointments![index].id;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].createdAt;
  }

  @override
  DateTime getEndTime(int index) {
    if(appointments![index].endTime != null){
      return appointments![index].endTime;
    }else{
    return appointments![index].endTime = appointments![index].createdAt.add(const Duration(hours: 2));
    }
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  Color getColor(int index) {
    return appointments![index].backgroundColor;
  }


}
