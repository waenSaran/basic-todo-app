import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateToEditPage;
  final Function(String) deleteTaskById;
  const TaskCard(
      {super.key,
      required this.index,
      required this.item,
      required this.navigateToEditPage,
      required this.deleteTaskById});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          onSelected: (value) {
            final id = item['_id'];
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
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ];
          },
        ),
      ),
    );
  }
}
