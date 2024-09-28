import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';

class TastItem extends StatefulWidget {
  final Task task;
  const TastItem({super.key, required this.task});

  @override
  State<TastItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TastItem> {
  TextEditingController _tasknameController = TextEditingController();
  late LocalStorage _localStorage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
      _tasknameController.text = widget.task.name;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10),
        ],
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          // Bu kısım ile to do listte check yapma kısmı oluşturulmuş
          child: Container(
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                border: Border.all(color: Colors.grey, width: 0.8),
                shape: BoxShape.circle),
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                controller: _tasknameController,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (newtask) {
                  if (newtask.length > 3) {
                    widget.task.name = newtask;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.createdAt),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
