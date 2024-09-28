import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/data/local_storage.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/widgets/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {

  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(onPressed: () {
        query.isEmpty ? null : query = '';
      }, icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // sol baştaki ikonlar
    return GestureDetector(onTap: (){
      close(context, null);
    },child: Icon(Icons.arrow_back_ios,color: Colors.black, size: 24,));
  }

  @override
  Widget buildResults(BuildContext context) {
    // arama tuşuna basılınca araması için burda yapılacak 
    List<Task> filteredList = allTasks.where((task)=> task.name.toLowerCase().contains(query.toLowerCase())).toList();
    return filteredList.length > 0 ? ListView.builder(
                itemBuilder: (context, index) {
                  var _listeleman = filteredList[index];
                  return Dismissible(
                      background:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "remove_task",
                            style: TextStyle(color: Colors.red),
                          ).tr()
                        ],
                      ),
                      key: Key(_listeleman.id),
                      onDismissed: (direction)  async{
                        filteredList.removeAt(index);
                        await locator<LocalStorage>().deleteTask(task: _listeleman);
                      },
                      child: TastItem(task: _listeleman));
                },
                itemCount: filteredList.length,
              ):  Center(child: Text("search_not_found").tr(),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}