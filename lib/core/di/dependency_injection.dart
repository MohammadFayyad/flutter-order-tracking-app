import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:order_tracking/features/add_order/cubit/order_cubit.dart';
import 'package:order_tracking/features/add_order/cubit/order_tracking_cubit.dart';
import 'package:order_tracking/features/add_order/repo/order_repo.dart';
import 'package:order_tracking/features/add_order/repo/order_tracking_repo.dart';
import 'package:order_tracking/features/add_order/services/driver_location_tracker.dart';
import 'package:order_tracking/features/add_order/services/driver_simulator_service.dart';
import 'package:order_tracking/features/add_order/services/map_service.dart';
import 'package:order_tracking/features/auth/cubit/auth_cubit.dart';
import 'package:order_tracking/features/auth/repo/auth_repo.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  //services
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<Dio>(() => Dio());

  //repos
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepo(
      firebaseAuth: sl<FirebaseAuth>(),
      firebaseFirestore: sl<FirebaseFirestore>(),
    ),
  );
  sl.registerLazySingleton<OrderRepo>(
    () => OrderRepo(
      firebaseFirestore: sl<FirebaseFirestore>(),
      firebaseAuth: sl<FirebaseAuth>(),
    ),
  );
  sl.registerLazySingleton<OrderTrackingRepo>(
    () => OrderTrackingRepo(
      firebaseFirestore: sl<FirebaseFirestore>(),
      dio: sl<Dio>(),
    ),
  );

  //services
  sl.registerLazySingleton<MapService>(() => MapService(dio: sl<Dio>()));
  sl.registerLazySingleton<DriverSimulatorService>(
    () => DriverSimulatorService(firebaseFirestore: sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<DriverLocationTracker>(
    () => DriverLocationTracker(firebaseFirestore: sl<FirebaseFirestore>()),
  );

  //cubits
  sl.registerFactory(() => AuthCubit(sl<AuthRepo>()));
  sl.registerFactory(() => OrderCubit(sl<OrderRepo>()));
  sl.registerFactory(
    () => OrderTrackingCubit(
      orderTrackingRepo: sl<OrderTrackingRepo>(),
      orderRepo: sl<OrderRepo>(),
      mapService: sl<MapService>(),
      driverSimulator: sl<DriverSimulatorService>(),
    ),
  );
}
