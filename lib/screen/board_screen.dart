import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker_pro/bloc/auth/auth_bloc.dart';
import 'package:task_tracker_pro/bloc/auth/auth_event.dart';
import 'package:task_tracker_pro/bloc/board/board_bloc.dart';
import 'package:task_tracker_pro/bloc/board/board_event.dart';
import 'package:task_tracker_pro/bloc/board/board_state.dart';
import 'package:task_tracker_pro/model/draggable_model.dart';
import 'package:task_tracker_pro/screen/add_task_screen.dart';
import 'package:task_tracker_pro/widgets/board_widget.dart';
import 'package:task_tracker_pro/widgets/pop_widget.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BoardBloc>().add(LoadBoardEvent());
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width / 1.2;
    const backgroundColor = Color.fromARGB(255, 243, 242, 248);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Board Screen"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Add Board",
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddBoardPopup(),
              );
            },
          ),
          IconButton(
            tooltip: "Sign Out",
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<BoardBloc>().add(const DeleteBoardEvent());
              context.read<AuthBloc>().add(AuthLogoutEvent());
              context.go("/");
            },
          ),
        ],
      ),
      body: BlocListener<BoardBloc, BoardState>(
        listener: (context, state) {
          if (state is BoardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is BoardSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Card added")),
            );
          }
          if (state is BoardDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Card deleted")),
            );
          }
        },
        child: BlocBuilder<BoardBloc, BoardState>(
          builder: (context, state) {
            if (state is BoardLoading || state is BoardReOrder) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BoardLoaded) {
              return Column(
                children: [
                  if (state.lists.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22.0, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const DraggableItemForm(),
                                ).then((onValue) {
                                  setState(() {});
                                });
                                // context.push("/dragForm");
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4)))),
                              child: const Text("Add Task +"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Divider(),
                  Expanded(
                    child: DragAndDropLists(
                      listPadding: const EdgeInsets.all(16),
                      listInnerDecoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      children: state.lists.map(buildList).toList(),
                      axis: Axis.horizontal,
                      listWidth: width,
                      listDraggingWidth: width,
                      itemDivider: const Divider(
                          thickness: 2, height: 2, color: backgroundColor),
                      itemDecorationWhileDragging: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      // listDragHandle: buildDragHandle(isList: true),
                      // itemDragHandle: buildDragHandle(),
                      onItemReorder: (oldItemIndex, oldListIndex, newItemIndex,
                          newListIndex) {
                        context.read<BoardBloc>().add(ReorderListItemEvent(
                            oldItemIndex,
                            oldListIndex,
                            newItemIndex,
                            newListIndex));
                      },
                      contentsWhenEmpty: Row(
                        children: <Widget>[
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 40, right: 10),
                              child: Divider(),
                            ),
                          ),
                          Text(
                            'Empty List',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color,
                                fontStyle: FontStyle.italic),
                          ),
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 40),
                              child: Divider(),
                            ),
                          ),
                        ],
                      ),
                      onListReorder: (oldListIndex, newListIndex) {
                        context
                            .read<BoardBloc>()
                            .add(ReorderListEvent(oldListIndex, newListIndex));
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Failed to load batches.'));
            }
          },
        ),
      ),
    );
  }

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAlignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;
    final color = isList ? Colors.blueGrey : Colors.black26;

    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Container(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(Icons.menu, color: color),
      ),
    );
  }

  DragAndDropList buildList(DraggableModel list) => DragAndDropList(
        header: Container(
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: list.color, width: 3.0),
            ),
          ),
          child: Text(
            list.header,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        children: list.items
            .map(
              (item) => DragAndDropItem(
                child: BoardWidget(draggableModelItem: item),
              ),
            )
            .toList(),
      );
}
