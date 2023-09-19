import 'dart:convert';

import 'package:basic_todo_app/screens/add-todo.dart';
import 'package:basic_todo_app/services/todoApi.dart';
import 'package:basic_todo_app/utils/snackbarHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = false;
  List todoList = [];

  @override
  void initState() {
    super.initState();
    fetchTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Todo List')),
        body: Visibility(
            visible: !isLoading,
            replacement: const Center(child: CircularProgressIndicator()),
            child: RefreshIndicator(
                onRefresh: fetchTodoList,
                child: Visibility(
                  visible: todoList.isNotEmpty,
                  replacement: Center(
                      child: Text(
                    'No Task!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )),
                  child: ListView.builder(
                      itemCount: todoList.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        final item = todoList[index];
                        final id = item['_id'];
                        return Card(
                          child: ListTile(
                            title: Text(item['title']),
                            subtitle: Text(item['description']),
                            trailing: PopupMenuButton(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  // Go to edit page
                                  navigateToEditPage(item);
                                } else if (value == 'delete') {
                                  // Delete and remove the item
                                  deleteTaskById(id);
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem(
                                      value: 'delete', child: Text('Delete')),
                                ];
                              },
                            ),
                          ),
                        );
                      }),
                ))),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage,
          label: const Text("Add Task"),
          icon: const Icon(Icons.add_circle_outline),
        ));
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodoList();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(task: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodoList();
  }

  Future<void> fetchTodoList() async {
    final response = await TodoServices.fetchTaskList();
    if (response != null) {
      setState(() {
        todoList = response;
      });
    } else {
      showErrorMessage(context, message: 'Something went wrong!');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteTaskById(String id) async {
    // Delete via api
    final isSuccess = await TodoServices.deleteTaskById(id);
    if (isSuccess) {
      // Remove from the list
      final filteredItems =
          todoList.where((task) => task['_id'] != id).toList();
      setState(() {
        todoList = filteredItems;
      });
      showSuccessMessage(context, message: 'Delete task successfully');
    } else {
      showErrorMessage(context, message: 'Something went wrong, try again');
    }
  }
}
