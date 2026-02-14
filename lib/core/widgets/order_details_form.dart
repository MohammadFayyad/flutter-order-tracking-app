import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_tracking/core/styling/app_colors.dart';
import 'package:order_tracking/core/styling/app_styles.dart';
import 'package:order_tracking/core/widgets/custom_text_field.dart';
import 'package:order_tracking/core/widgets/spacing_widgets.dart';

class OrderDetailsForm extends StatelessWidget {
  OrderDetailsForm({
    super.key,
    required this.arrivalDateController,
    required this.orderIdController,
    required this.orderNameController,
  });

  final TextEditingController arrivalDateController;
  late DateTime orderArrivalDate;
  final TextEditingController orderIdController;
  final TextEditingController orderNameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text("Order Id", style: AppStyles.black16w500Style),
        const HeightSpace(8),
        CustomTextField(
          controller: orderIdController,
          hintText: "Enter Your Order Id",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter Your Order Id";
            }
            return null;
          },
        ),
        const HeightSpace(12),
        Text("Arrival Date", style: AppStyles.black16w500Style),
        const HeightSpace(8),
        CustomTextField(
          readOnly: true,
          controller: arrivalDateController,
          hintText: "Enter Arrival Date",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter Your Arrival Date";
            }
            return null;
          },
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primaryColor,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              orderArrivalDate = pickedDate;
              arrivalDateController.text = DateFormat(
                "yyyy-MM-dd",
              ).format(pickedDate);
            }
          },
        ),
        const HeightSpace(12),
        Text("Order Name", style: AppStyles.black16w500Style),
        const HeightSpace(8),
        CustomTextField(
          controller: orderNameController,
          hintText: "Enter Your Order Name",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter Your Order Name";
            }
            return null;
          },
        ),
      ],
    );
  }
}
