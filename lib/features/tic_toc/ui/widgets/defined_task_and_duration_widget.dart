import 'package:flutter/material.dart';
import 'package:tic_toc_game/utils/app_text_field/app_text_field.dart';
import 'package:tic_toc_game/utils/consts.dart';
import 'package:tic_toc_game/utils/helpers/spacer.dart';
import 'package:tic_toc_game/utils/text_styles/text_styles.dart';

import '../../../../utils/app_button/app_button.dart';
import '../../../../utils/colors/app_colors.dart';

class DefinedTaskAndDurationWidget extends StatefulWidget {
  const DefinedTaskAndDurationWidget(
      {super.key,
      required this.taskCount,
      required this.sequence,
      required this.onTap});

  final TextEditingController taskCount;
  final TextEditingController sequence;
  final VoidCallback onTap;

  @override
  State<DefinedTaskAndDurationWidget> createState() =>
      _DefinedTaskAndDurationWidgetState();
}

class _DefinedTaskAndDurationWidgetState
    extends State<DefinedTaskAndDurationWidget> {
  bool _isFilled() {
    if ((widget.sequence.text.isNotEmpty) &&
        (widget.sequence.text.isNotEmpty) &&
        validateCreateTasks() == true) {
      return true;
    } else {
      return false;
    }
  }

  bool validateCreateTasks() {
    final int taskCount = int.parse(widget.taskCount.text);
    final int sequence = int.parse(widget.sequence.text);
    if (taskCount > sequence) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(50),
        AppTextField(
          controller: widget.taskCount,
          label: Consts.numberTaskField,
          onChanged: (p0) {
            _isFilled();
            setState(() {});
          },
        ),
        verticalSpace(20),
        AppTextField(
          validator: (p0) {
            return _isFilled() == true
                ? null
                : 'Task sequence must be equal to task count or greater';
          },
          controller: widget.sequence,
          label: Consts.sequenceTaskField,
          onChanged: (p0) {
            _isFilled();
            setState(() {});
          },
        ),
        verticalSpace(30),
        AppButton(
          color: _isFilled() == true
              ? ColorsManger.praimaryColor()
              : Colors.grey.shade200,
          onTap: widget.onTap,
          height: Consts.mainProprityHeight,
          child: Text(
            "Goo",
            style: Styles.bold(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
