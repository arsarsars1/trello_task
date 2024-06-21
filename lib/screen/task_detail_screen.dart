import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_pro/bloc/board/board_bloc.dart';
import 'package:task_tracker_pro/bloc/board/board_event.dart';
import 'package:task_tracker_pro/bloc/board/board_state.dart';
import 'package:task_tracker_pro/model/comment_model.dart';
import 'package:task_tracker_pro/model/contact.dart';
import 'package:task_tracker_pro/model/draggable_model.dart';
import 'package:task_tracker_pro/model/draggable_model_item.dart';
import 'package:task_tracker_pro/utils/extension.dart';
import 'package:task_tracker_pro/utils/utils.dart';

class TaskDetailsPage extends StatefulWidget {
  final DraggableModelItem task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {
        context.read<BoardBloc>().add(StopTimerEvent(task: widget.task));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.task.title),
        ),
        body: BlocBuilder<BoardBloc, BoardState>(builder: (context, state) {
          DraggableModelItem task = findItem(state.lists);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text.rich(
                        textAlign: TextAlign.start,
                        TextSpan(children: [
                          const TextSpan(
                            text: "Priority: ",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: task.priority.name,
                          ),
                        ]),
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        textAlign: TextAlign.start,
                        TextSpan(children: [
                          const TextSpan(
                            text: "Category: ",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: task.category,
                          ),
                        ]),
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        textAlign: TextAlign.start,
                        TextSpan(children: [
                          const TextSpan(
                            text: "Task Duration: ",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                "From ${Utils.convertDateToString(task.startTime, isFormatDate: true)} "
                                "to ${Utils.convertDateToString(task.endTime, isFormatDate: true)}",
                            style: TextStyle(
                              color: Utils.isDateToday(task.endTime)
                                  ? Colors.red
                                  : null,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        textAlign: TextAlign.start,
                        TextSpan(children: [
                          const TextSpan(
                            text: 'Description ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: widget.task.description,
                          ),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      if (task.timeSpent != null && task.completedDate != null)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Completed Tasks:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    textAlign: TextAlign.start,
                                    TextSpan(children: [
                                      const TextSpan(
                                        text: 'Total time spent: ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${task.timeSpent?.inMinutes}:'
                                            '${(task.timeSpent != null ? (task.timeSpent!.inSeconds % 60) : "").toString().padLeft(2, '0')}',
                                      ),
                                    ]),
                                  ),
                                  Text.rich(
                                    textAlign: TextAlign.start,
                                    TextSpan(children: [
                                      const TextSpan(
                                        text: 'Start time: ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: Utils.formatTimeAgo(task
                                                .startDateTime ??
                                            DateTime.now().toIso8601String()),
                                      ),
                                    ]),
                                  ),
                                  Text.rich(
                                    textAlign: TextAlign.start,
                                    TextSpan(children: [
                                      const TextSpan(
                                        text: 'Completed on: ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: Utils.formatTimeAgo(
                                            task.completedDate!),
                                      ),
                                    ]),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTimer(context, state, task),
                            ]),
                      const Text(
                        'Contacts:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: task.peoples.length,
                        itemBuilder: (context, index) {
                          Contact contact = task.peoples[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    textAlign: TextAlign.start,
                                    TextSpan(children: [
                                      const TextSpan(
                                        text: "Name: ",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: contact.name,
                                      ),
                                    ]),
                                  ),
                                  Text.rich(
                                    textAlign: TextAlign.start,
                                    TextSpan(children: [
                                      const TextSpan(
                                        text: "Email: ",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: contact.email,
                                      ),
                                    ]),
                                  ),
                                ]),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Comments:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: task.comment.length,
                        itemBuilder: (context, index) {
                          final comment = task.comment[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    textAlign: TextAlign.start,
                                    TextSpan(children: [
                                      TextSpan(
                                        text: "${comment.author.name} ",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: comment.comment,
                                      ),
                                    ]),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    Utils.formatTimeAgo(comment.createdAt),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          );
                        },
                      ),
                      const SizedBox(height: 4)
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: commentController,
                          decoration: const InputDecoration(
                            labelText: 'Add Comment',
                            border: InputBorder.none,
                          ),
                          onFieldSubmitted: (value) {
                            sendMessage(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          sendMessage(null);
                        },
                        child: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTimer(
      BuildContext context, BoardState state, DraggableModelItem task) {
    if (state is BoardRunning) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            'Start time: ${Utils.formatTimeAgo(state.task.startDateTime ?? DateTime.now().toIso8601String())}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Time Spent: ${state.elapsedTime.inMinutes}:${(state.elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<BoardBloc>().add(StopTimerEvent(task: task));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)))),
                  child: const Text('Reset Timer'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<BoardBloc>().add(CompleteTaskEvent());
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)))),
                  child: const Text('Complete Task'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<BoardBloc>()
                      .add(StartTimerEvent(task: widget.task));
                },
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)))),
                child: const Text('Start Timer'),
              ),
            ),
          ),
        ],
      );
    }
  }

  DraggableModelItem findItem(List<DraggableModel> lists) {
    DraggableModel? item = lists.safeFirstWhere(
        ((DraggableModel model) => model.boardId == widget.task.boardId));
    if (item != null) {
      DraggableModelItem? draggableModelItem =
          item.items.safeFirstWhere((dragItem) => dragItem == widget.task);
      if (draggableModelItem != null) {
        return draggableModelItem;
      } else {
        return widget.task;
      }
    } else {
      return widget.task;
    }
  }

  void sendMessage(String? value) {
    final comment = CommentModel(
      author: Contact(name: 'User', email: "ars@gmail.com"),
      comment: value ?? commentController.text,
      createdAt: Utils.convertDateToString(DateTime.now()),
      id: Utils.generateRandomId(),
    );
    context
        .read<BoardBloc>()
        .add(AddCommentEvent(task: widget.task, comment: comment));
    setState(() {});
    commentController.clear();
  }
}
