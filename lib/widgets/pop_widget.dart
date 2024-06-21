import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:task_tracker_pro/bloc/board/board_bloc.dart';
import 'package:task_tracker_pro/bloc/board/board_event.dart';
import 'package:task_tracker_pro/model/draggable_model.dart';
import 'package:task_tracker_pro/utils/utils.dart';

class AddBoardPopup extends StatefulWidget {
  const AddBoardPopup({super.key});

  @override
  State<AddBoardPopup> createState() => _AddBoardPopupState();
}

class _AddBoardPopupState extends State<AddBoardPopup> {
  final _formKey = GlobalKey<FormState>();
  final _boardNameController = TextEditingController();
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Board'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _boardNameController,
              decoration: const InputDecoration(labelText: 'Board Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a board name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showColorPicker(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)))),
              child: const Text('Pick Color'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final boardName = _boardNameController.text;
              final newBoard = DraggableModel(
                boardId: Utils.generateRandomId().toString(),
                header: boardName,
                color: _selectedColor,
                dateTime: DateTime.now(),
                items: [],
              );
              context.read<BoardBloc>().add(AddBoardEvent(newBoard));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _boardNameController.dispose();
    super.dispose();
  }
}
