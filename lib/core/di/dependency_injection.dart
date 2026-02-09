import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:order_tracking/features/add_order_screen/cubit/order_cubit.dart';
import 'package:order_tracking/features/add_order_screen/repo/order_repo.dart';
import 'package:order_tracking/features/auth/cubit/auth_cubit.dart';
import 'package:order_tracking/features/auth/repo/auth_repo.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  //services
  sl.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
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
    ),
  );
  //cubits
  sl.registerFactory(() => AuthCubit(sl<AuthRepo>()));
  sl.registerFactory(() => OrderCubit(sl<OrderRepo>()));
}
