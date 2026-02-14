import 'package:get_it/get_it.dart';
import 'package:order_tracking/core/utils/storage_helper.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton(() => StorageHelper());
}
