class OrderModel {
  String? orderId;
  String? orderName;
  String? orderLatitude;
  String? orderLongitude;
  String? orderStatus;
  String? orderDate;
  String? orderUserId;
  UserModel? userModel;

  OrderModel({
    this.orderId,
    this.orderName,
    this.orderLatitude,
    this.orderLongitude,
    this.orderStatus,
    this.orderDate,
    this.orderUserId,
    this.userModel,
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
    'userModel': userModel?.toJson(),
  };
}

class UserModel {
  String? userLatitude;
  String? userLongitude;
  UserModel({this.userLatitude, this.userLongitude});
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
}
