import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_tracking/features/add_order/models/add_order_model.dart';
import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';

class OrderRepo {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  OrderRepo({required this.firebaseFirestore, required this.firebaseAuth});
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

  Future<ResultDart<List<OrderModel>, String>> getOrder() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firebaseFirestore
              .collection("orders")
              .where("orderUserId", isEqualTo: firebaseAuth.currentUser!.uid)
              .get();
      List<OrderModel> orderList = querySnapshot.docs
          .map((e) => OrderModel.fromJson(e.data()))
          .toList();
      return successOf(orderList);
    } on FirebaseException catch (e) {
      return failureOf(e.toString());
    } on Exception catch (_) {
      return failureOf("error occurred");
    }
  }

  Future<ResultDart<void, String>> updateOrderStatus({
    required String orderId,
    required String newStatus,
  }) async {
    try {
      await firebaseFirestore.collection("orders").doc(orderId).update({
        'orderStatus': newStatus,
      });
      return successOf(unit);
    } on FirebaseException catch (e) {
      return failureOf(e.toString());
    } on Exception catch (_) {
      return failureOf("error occurred while updating status");
    }
  }
}
