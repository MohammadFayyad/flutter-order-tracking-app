import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String? orderId;
  final String? orderName;
  final String? orderLatitude;
  final String? orderLongitude;
  final String? orderStatus;
  final String? orderDate;
  final String? orderUserId;
  final UserModel? userModel;
  final String? orderAddress;

  const OrderModel({
    required this.orderId,
    required this.orderName,
    required this.orderLatitude,
    required this.orderLongitude,
    required this.orderStatus,
    required this.orderDate,
    required this.orderUserId,
    required this.userModel,
    required this.orderAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      orderName: json['orderName'],
      orderLatitude: json['orderLatitude'],
      orderLongitude: json['orderLongitude'],
      orderStatus: json['orderStatus'],
      orderDate: json['orderDate'],
      orderUserId: json['orderUserId'],
      orderAddress: json['orderAddress'],
      userModel: UserModel.fromJson(json['userModel']),
    );
  }
  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'orderName': orderName,
    'orderLatitude': orderLatitude,
    'orderLongitude': orderLongitude,
    'orderStatus': orderStatus,
    'orderDate': orderDate,
    'orderUserId': orderUserId,
    'orderAddress': orderAddress,
    'userModel': userModel?.toJson(),
  };
  @override
  List<Object?> get props => [
    orderId,
    orderName,
    orderLatitude,
    orderLongitude,
    orderStatus,
    orderDate,
    orderUserId,
    userModel,
    orderAddress,
  ];
}

class UserModel extends Equatable {
  final String? userLatitude;
  final String? userLongitude;
  const UserModel({required this.userLatitude, required this.userLongitude});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userLatitude: json['userLatitude'],
      userLongitude: json['userLongitude'],
    );
  }
  Map<String, dynamic> toJson() => {
    'userLatitude': userLatitude,
    'userLongitude': userLongitude,
  };
  @override
  List<Object?> get props => [userLatitude, userLongitude];
}
