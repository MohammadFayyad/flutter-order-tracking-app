import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking/features/add_order_screen/cubit/order_state.dart';
import 'package:order_tracking/features/add_order_screen/models/add_order_model.dart';
import 'package:order_tracking/features/add_order_screen/repo/order_repo.dart';
import 'package:result_dart/result_dart.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this.orderRepo) : super(OrderInitial());

  OrderRepo orderRepo;

  void addOrder() async {
    emit(OrderLoading());
    ResultDart<String, String> result = await orderRepo.addOrder(OrderModel());
    if (isClosed) return;
    result.fold(
      (errorMessage) => emit(OrderError(message: errorMessage)),
      (message) => emit(OrderSuccess(message: message)),
    );
  }
}
