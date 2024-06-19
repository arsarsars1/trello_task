import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker_pro/bloc/board/board_bloc.dart';
import 'package:task_tracker_pro/bloc/board/board_event.dart';
import 'package:task_tracker_pro/bloc/board/board_state.dart';
import 'package:task_tracker_pro/model/contact.dart' show Contact;
import 'package:task_tracker_pro/model/draggable_model_item.dart'
    show DraggableModelItem;
import 'package:task_tracker_pro/model/priority.dart';
import 'package:task_tracker_pro/utils/utils.dart';

class DraggableItemForm extends StatefulWidget {
  final DraggableModelItem? draggableModelItem;
  const DraggableItemForm({super.key, this.draggableModelItem});

  @override
  State<DraggableItemForm> createState() => _DraggableItemFormState();
}

class _DraggableItemFormState extends State<DraggableItemForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formContactKey = GlobalKey<FormState>();
  final List<Contact> _contacts = [];
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  DraggableModelItem? draggableModelItem;

  @override
  void initState() {
    super.initState();
    updateModel();
  }

  updateModel() {
    if (widget.draggableModelItem != null) {
      _contacts.addAll(widget.draggableModelItem!.peoples);
      draggableModelItem = widget.draggableModelItem;
    }
    setState(() {});
  }

  void _addContact() {
    if (_formContactKey.currentState?.validate() ?? false) {
      setState(() {
        _contacts.add(Contact(
          name: _nameController.text,
          email: _emailController.text,
        ));
        _nameController.clear();
        _emailController.clear();
      });
    }
  }

  void _removeContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(22)),
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text('Draggable Item Form'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            initialValue: {
              'title': draggableModelItem?.title,
              'description': draggableModelItem?.description,
              'priority': draggableModelItem?.priority,
              'dateTime': draggableModelItem != null
                  ? DateTimeRange(
                      start: draggableModelItem!.startTime,
                      end: draggableModelItem!.endTime,
                    )
                  : null,
              'category': draggableModelItem?.category,
              'boardId': draggableModelItem?.boardId,
            },
            child: ListView(
              children: [
                FormBuilderTextField(
                  name: 'title',
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderTextField(
                  name: 'description',
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderDropdown(
                  name: 'priority',
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: Priority.values
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority.toString().split('.').last),
                          ))
                      .toList(),
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderDateRangePicker(
                  name: 'dateTime',
                  firstDate: DateTime(1990),
                  lastDate: DateTime(2050),
                  decoration:
                      const InputDecoration(labelText: 'Date Time Picker'),
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderTextField(
                  name: 'category',
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: FormBuilderValidators.required(),
                ),
                BlocBuilder<BoardBloc, BoardState>(builder: (context, state) {
                  if (state is BoardLoaded) {
                    return FormBuilderDropdown(
                      name: 'boardId',
                      decoration:
                          const InputDecoration(labelText: 'Card Board'),
                      items: state.lists
                          .map((dragModel) => DropdownMenuItem(
                                value: dragModel.boardId,
                                child: Text(dragModel.header),
                              ))
                          .toList(),
                      validator: FormBuilderValidators.required(),
                    );
                  } else {
                    return const Center(child: Text('Failed to load batches.'));
                  }
                }),
                const SizedBox(height: 8),
                Form(
                  key: _formContactKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Contacts"),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'contact_name',
                              controller: _nameController,
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                              validator: FormBuilderValidators.required(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'contact_email',
                              controller: _emailController,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addContact,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(_contacts.length, (index) {
                  final contact = _contacts[index];
                  return ListTile(
                    title: Text(contact.name),
                    subtitle: Text(contact.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeContact(index),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final formData = _formKey.currentState?.value;
                      if (_contacts.isNotEmpty && formData != null) {
                        List<String> dateList =
                            formData["dateTime"].toString().split(" - ");

                        final draggableItem = DraggableModelItem(
                          id: Utils.generateRandomId(),
                          title: formData['title'],
                          description: formData['description'],
                          priority: formData['priority'],
                          comment: [],
                          startTime: DateTime.parse(dateList.first),
                          endTime: DateTime.parse(dateList[1]),
                          createdAt: DateTime.now().toLocal().toString(),
                          category: formData['category'],
                          boardId: formData["boardId"],
                          tasks: [],
                          peoples: _contacts,
                        );
                        if (draggableModelItem != null) {
                          context.read<BoardBloc>().add(AddBoardItemEvent(
                              boardId: formData["boardId"],
                              dragItem: draggableItem));
                        } else {
                          context.read<BoardBloc>().add(AddBoardItemEvent(
                              boardId: formData["boardId"],
                              dragItem: draggableItem));
                        }
                        context.pop();
                      } else {
                        if (_formContactKey.currentState?.validate() ?? false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Contact is required")));
                        } else {
                          _formContactKey.currentState?.validate();
                        }
                      }
                    } else {
                      if (_contacts.isEmpty) {
                        _formContactKey.currentState?.validate();
                      }
                    }
                  },
                  child: Text(draggableModelItem != null ? "Update" : 'Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
