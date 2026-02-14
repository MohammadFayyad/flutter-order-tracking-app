import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order_tracking/core/styling/app_assets.dart';
import 'package:order_tracking/core/styling/app_styles.dart';
import 'package:order_tracking/core/widgets/spacing_widgets.dart';

/// Header section for Add Order screen
/// Contains title, subtitle, and logo image
class AddOrderHeader extends StatelessWidget {
  const AddOrderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeightSpace(28),
        SizedBox(
          width: 335.w,
          child: Text(
            "Create Your New Order",
            style: AppStyles.primaryHeadLinesStyle,
          ),
        ),
        const HeightSpace(8),
        SizedBox(
          width: 335.w,
          child: Text(
            "Let's create your new order.",
            style: AppStyles.grey12MediumStyle,
          ),
        ),
        const HeightSpace(20),
        Center(
          child: Image.asset(
            AppAssets.logo,
            width: 190.w,
            height: 190.w,
          ),
        ),
        const HeightSpace(32),
      ],
    );
  }
}

