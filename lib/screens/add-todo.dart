import 'package:basic_todo_app/services/todoApi.dart';
import 'package:basic_todo_app/utils/snackbarHelper.dart';
import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  final Map? task;
  const AddTodoPage({super.key, this.task});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    if (task != null) {
      isEditing = true;
      final title = task['title'];
      final description = task['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Add New Task')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Task'),
            controller: titleController,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            minLines: 5,
            maxLines: 10,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEditing ? updateData : submitData,
              child: const Text('Save')),
        ],
      ),
    );
  }

  void submitData() async {
    // Submit to server
    final isSuccess = await TodoServices.addTask(body);
    // Show message depends on
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'Create task successfully');
    } else {
      showErrorMessage(context, message: 'Sorry, try again!');
    }
  }

  void updateData() async {
    // Get data from form
    final task = widget.task;
    if (task == null) {
      print('Cannot update without any data');
      return;
    }
    final id = task['_id'];
    // Submit to server
    final isSuccess = await TodoServices.updateTask(id, body);
    // Show message depends on
    if (isSuccess) {
      showSuccessMessage(context, message: 'Update task successfully');
    } else {
      showErrorMessage(context, message: 'Sorry, try again!');
    }
  }

  Map get body {
    // Get data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {"title": title, "description": description, "is_completed": false};
  }
}
