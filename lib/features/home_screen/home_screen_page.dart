import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/styling/app_colors.dart';
import 'package:order_tracking/features/auth/models/user_model.dart';

class HomeScreen extends StatelessWidget {
  final UserModel userModel;
  const HomeScreen({super.key, required this.userModel});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Home Screen",
          style: TextStyle(color: AppColors.primaryColor),
        ),
        leading: Icon(Icons.menu, color: AppColors.primaryColor),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.sp),
        child: SizedBox(
          height: 220.h,
          child: ListView(
            scrollDirection: .horizontal,
            children: [
              InkWell(
                onTap: () {
                  context.push(AppRoutes.myOrdersScreen);
                },
                child: Container(
                  height: 50.h,
                  width: 160.w,
                  margin: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Center(
                    child: Text(
                      "Orders",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  context.push(AppRoutes.addOrderScreen);
                },
                child: Container(
                  height: 250.h,
                  width: 160.w,
                  margin: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Center(
                    child: Text(
                      "Add Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
