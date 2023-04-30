import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/widgets/alert_user.dart';

import '../provider/task.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final bool needTrailingColor;
  final Color backgroundColor;
  const TaskItem(this.task, this.needTrailingColor, this.backgroundColor,
      {super.key});
  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Color kColor = widget.backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
    return Column(
      children: [
        GestureDetector(
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) => AlertUser(id: widget.task.id));
          },
          child: ListTile(
            leading: Transform.scale(
              scale: 1.4,
              child: Checkbox(
                  side: BorderSide(width: 0.7, color: kColor),
                  shape: const CircleBorder(),
                  // checkColor: Colors.blue,
                  value: isChecked,
                  onChanged: (val) {
                    setState(() {
                      print('setstate');
                      isChecked = val!;
                    });
                  }),
            ),
            title: Text(
              widget.task.title,
              style: TextStyle(
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                  color: kColor,
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: kColor.withAlpha(130),
                ),
                Text(
                  DateFormat.MMMMd().format(widget.task.taskDate),
                  style: TextStyle(color: kColor.withAlpha(130)),
                ),
                Padding(padding: EdgeInsets.only(left: screenWidth / 30)),
                Icon(
                  Icons.timer_outlined,
                  color: kColor.withAlpha(130),
                ),
                Text(
                  DateFormat.jm().format(widget.task.taskTime),
                  style: TextStyle(color: kColor.withAlpha(130)),
                ),
              ],
            ),
            trailing: SizedBox(
                width: 14,
                height: 14,
                child: CircleAvatar(
                  backgroundColor: widget.needTrailingColor
                      ? widget.task.color
                      : Colors.transparent,
                )),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 80),
          child: Divider(
            color: kColor.withAlpha(255),
          ),
        ),
      ],
    );
  }
}
