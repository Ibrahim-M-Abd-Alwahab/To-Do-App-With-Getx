import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
  final RxList<Tasks> taskList = <Tasks>[].obs;
  Future<int> addTask({Tasks? task}) {
    return DBHelper.dbHelperObject.insert(task!);
  }

  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks =
        await DBHelper.dbHelperObject.query();
    taskList.assignAll(tasks.map((data) => Tasks.fromMap(data)).toList());
  }

  void deleteTasks(Tasks task) async {
    await DBHelper.dbHelperObject.delete(task);
    getTasks();
  }

  void deleteAllTasks() async {
    await DBHelper.dbHelperObject.deleteAll();
    getTasks();
  }

  void markUsCompleted(int id) async {
    await DBHelper.dbHelperObject.update(id);
    getTasks();
  }
}
