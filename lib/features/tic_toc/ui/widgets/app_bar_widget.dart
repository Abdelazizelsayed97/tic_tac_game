import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tic_toc_game/utils/text_styles/text_styles.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, this.bottom});
final PreferredSizeWidget? bottom;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Tic Tac Toe",
        style: Styles.bold(fontSize: 28,fontStyle: FontStyle.italic),
      ),
      centerTitle: true,
      bottom:bottom ,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
