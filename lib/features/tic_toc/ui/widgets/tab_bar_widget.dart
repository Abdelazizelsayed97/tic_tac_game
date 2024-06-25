import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/colors/app_colors.dart';
import '../../../../utils/consts.dart';
import '../../../../utils/helpers/app_daimentions.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({super.key});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
          borderRadius: AppDimensions.radiusLarge(radius: 30.r),
          color: ColorsManger.praimaryColor()),
      child: TabBar(
        onTap: (value) {},
        overlayColor: const MaterialStatePropertyAll<Color>(Colors.red),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
        ),
        splashBorderRadius: BorderRadius.circular(50),
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(text: Consts.tabsTitles[0]),
          Tab(text: Consts.tabsTitles[1]),
          Tab(text: Consts.tabsTitles[2]),
        ],
      ),
    );
  }
}
