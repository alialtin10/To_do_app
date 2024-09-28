import 'package:hive/hive.dart';
import 'package:to_do_app/models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}


class HiveLocalStorage implements LocalStorage{
  late Box<Task> _taskBox;

  HiveLocalStorage(){
    _taskBox = Hive.box<Task>('tasks');
  }

  @override
  Future<void> addTask({required Task task}) async {
    // TODO: implement addTask
    await _taskBox.put(task.id, task);

  }

  @override
  Future<bool> deleteTask({required Task task}) async{
    // TODO: implement deleteTask
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask()async {
    // TODO: implement getAllTask
    List<Task> _allTask = <Task>[];
    _allTask = _taskBox.values.toList();

    if(_allTask.isNotEmpty)
    {
      _allTask.sort((Task a , Task b) => b.createdAt.compareTo(a.createdAt));
    }
    return _allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async{
    // TODO: implement getTask
    if(_taskBox.containsKey(id)){
      return _taskBox.get(id);
    }else{
      return null;
    }
  }

  @override
  Future<Task> updateTask({required Task task}) async{
    // TODO: implement updateTask
    await task.save();
    return task;
  }

}