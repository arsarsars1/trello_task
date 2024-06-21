import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_tracker_pro/bloc/board/board_bloc.dart';
import 'package:task_tracker_pro/bloc/board/board_event.dart';
import 'package:task_tracker_pro/model/draggable_model_item.dart';
import 'package:task_tracker_pro/screen/add_task_screen.dart';
import 'package:task_tracker_pro/screen/task_detail_screen.dart';
import 'package:task_tracker_pro/utils/utils.dart';

class BoardWidget extends StatelessWidget {
  final DraggableModelItem draggableModelItem;
  const BoardWidget({super.key, required this.draggableModelItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetailsPage(task: draggableModelItem),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(draggableModelItem.title)),
            GestureDetector(
              onTapDown: (TapDownDetails details) async {
                await _showPopupMenu(context, details.globalPosition);
              },
              child: const Icon(
                Icons.more_horiz,
              ),
            )
          ]),
          const SizedBox(
            height: 4,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Text.rich(
                TextSpan(children: [
                  const TextSpan(
                    text: 'Priority ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: draggableModelItem.priority.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          Utils.getPriorityColor(draggableModelItem.priority),
                    ),
                  ),
                ]),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${draggableModelItem.comment.length}',
                    style: GoogleFonts.openSans(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  const Icon(
                    Icons.comment_bank,
                    size: 14,
                  ),
                ]),
          ]),
          const SizedBox(
            height: 4,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    Utils.convertDateToString(draggableModelItem.startTime),
                    textAlign: TextAlign.start,
                    style: GoogleFonts.openSans(
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    Utils.convertDateToString(draggableModelItem.startTime),
                    textAlign: TextAlign.start,
                    style: GoogleFonts.openSans(
                      fontSize: 12,
                    ),
                  ),
                ),
              ]),
        ]),
      ),
    );
  }

  Future<void> _showPopupMenu(BuildContext context, Offset position) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: [
        PopupMenuItem<String>(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) =>
                    DraggableItemForm(draggableModelItem: draggableModelItem),
              );
            },
            value: 'Edit',
            child: const Text('Edit')),
        PopupMenuItem<String>(
            onTap: () {
              context.read<BoardBloc>().add(DeleteBoardItemEvent(
                  boardId: draggableModelItem.boardId,
                  dragItem: draggableModelItem));
            },
            value: 'Delete',
            child: const Text('Delete')),
      ],
      elevation: 8.0,
    );
  }
}
