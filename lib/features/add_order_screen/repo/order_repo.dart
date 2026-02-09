import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_tracking/features/add_order_screen/models/add_order_model.dart';
import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';

class OrderRepo {
  final FirebaseFirestore firebaseFirestore;
  OrderRepo({required this.firebaseFirestore});
  Future<ResultDart<String, String>> addOrder(OrderModel orderModel) async {
    try {
      await firebaseFirestore
          .collection("orders")
          .doc(orderModel.orderId)
          .set(orderModel.toJson());
      return successOf("order added successfully");
    } on FirebaseException catch (e) {
      return failureOf(e.toString());
    } on Exception catch (_) {
      return failureOf("error occurred");
    }
  }
}
