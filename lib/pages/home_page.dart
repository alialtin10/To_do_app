import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/widgets/custom_search_delegate.dart';
import 'package:to_do_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              _showAddTaskBottomSheet();
            },
            child: const Text(
              "title",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ).tr(),
          ),
          centerTitle: false,
          actions: [
            IconButton(onPressed: () {
              _showSearhTask();
            }, icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  _showAddTaskBottomSheet();
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body: _allTasks.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  var _listeleman = _allTasks[index];
                  return Dismissible(
                      background:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                           Text(
                            'remove_task',
                            style: TextStyle(color: Colors.red),
                          ).tr()
                        ],
                      ),
                      key: Key(_listeleman.id),
                      onDismissed: (direction)  {
                        _allTasks.removeAt(index);
                        _localStorage.deleteTask(task: _listeleman);
                        setState(() {});
                      },
                      child: TastItem(task: _listeleman));
                },
                itemCount: _allTasks.length,
              )
            :  Center(
                child: Text('empty_task_list').tr(),
              ));
  }

  void _showAddTaskBottomSheet() {
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
              style:  const TextStyle(fontSize: 20),
              decoration:  InputDecoration(
                hintText: "add_task".tr(),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(context, showSecondsColumn: false,
                      onConfirm: (time) async {
                    var addNewTask = Task.create(name: value, createdAt: time);
                    _allTasks.insert(0, addNewTask);
                    await _localStorage.addTask(task: addNewTask);
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
  
  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {
      
    });
  }
  
  void _showSearhTask() async {
    await showSearch(context: context, delegate: CustomSearchDelegate(allTasks:  _allTasks));
    _getAllTaskFromDb();
  }
}
