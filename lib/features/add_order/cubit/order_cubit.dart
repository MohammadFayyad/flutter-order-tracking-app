import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking/features/add_order/cubit/order_state.dart';
import 'package:order_tracking/features/add_order/models/add_order_model.dart';
import 'package:order_tracking/features/add_order/repo/order_repo.dart';
import 'package:result_dart/result_dart.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this.orderRepo) : super(OrderInitial());

  OrderRepo orderRepo;

  void addOrder(OrderModel orderModel) async {
    emit(OrderLoading());
    ResultDart<String, String> result = await orderRepo.addOrder(orderModel);
    if (isClosed) return;
    result.fold(
      (message) => emit(OrderSuccess(message: message)),
      (errorMessage) => emit(OrderError(message: errorMessage)),
    );
  }

  void getOrder() async {
    emit(OrderLoading());
    ResultDart<List<OrderModel>, String> result = await orderRepo.getOrder();
    if (isClosed) return;
    result.fold(
      (orderList) => emit(OrderLoadedSuccess(orderList: orderList)),
      (errorMessage) => emit(OrderLoadedError(message: errorMessage)),
    );
  }
}
