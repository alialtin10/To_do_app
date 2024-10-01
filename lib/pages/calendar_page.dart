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
          if (details.targetElement == CalendarElement.calendarCell) {
            _showAddTaskBottomSheet(context);
          }
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
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Task> source) {
    appointments = source;
  }
}
