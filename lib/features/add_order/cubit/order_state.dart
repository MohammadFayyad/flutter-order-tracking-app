import 'package:equatable/equatable.dart';
import 'package:order_tracking/features/add_order/models/add_order_model.dart';

abstract class OrderState extends Equatable {
  const OrderState();
  @override
  List<Object?> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderSuccess extends OrderState {
  final String message;
  const OrderSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

final class OrderError extends OrderState {
  final String message;
  const OrderError({required this.message});
  @override
  List<Object?> get props => [message];
}

final class OrderLoadedSuccess extends OrderState {
  final List<OrderModel> orderList;
  const OrderLoadedSuccess({required this.orderList});
  @override
  List<Object?> get props => [orderList];
}

final class OrderLoadedError extends OrderState {
  final String message;
  const OrderLoadedError({required this.message});
  @override
  List<Object?> get props => [message];
}

final class OrderDeleteSuccess extends OrderState {
  final List<OrderModel> orderList;
  const OrderDeleteSuccess({required this.orderList});
  @override
  List<Object?> get props => [orderList];
}

final class OrderDeleteError extends OrderState {
  final String message;
  const OrderDeleteError({required this.message});
  @override
  List<Object?> get props => [message];
}
