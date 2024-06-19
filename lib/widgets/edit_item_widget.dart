import 'package:flutter/material.dart';
import 'package:task_tracker_pro/model/draggable_model_item.dart';

class EditDraggableModelItemDialog extends StatefulWidget {
  final DraggableModelItem item;

  const EditDraggableModelItemDialog({super.key, required this.item});

  @override
  State<EditDraggableModelItemDialog> createState() =>
      _EditDraggableModelItemDialogState();
}

class _EditDraggableModelItemDialogState
    extends State<EditDraggableModelItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = widget.item.title;
    _description = widget.item.description;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(labelText: 'Title'),
              onSaved: (value) => _title = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final updatedItem = widget.item.copyWith(
                title: _title,
                description: _description,
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

extension on DraggableModelItem {
  DraggableModelItem copyWith({
    String? title,
    String? description,
  }) {
    return DraggableModelItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority,
      urlImage: urlImage,
      comment: comment,
      startTime: startTime,
      endTime: endTime,
      createdAt: createdAt,
      category: category,
      boardId: boardId,
      tasks: tasks,
      peoples: peoples,
    );
  }
}
