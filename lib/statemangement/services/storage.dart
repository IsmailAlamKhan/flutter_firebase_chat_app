import 'package:get_storage/get_storage.dart';

class StorageService<T> {
  final box = GetStorage();

  T getValue(String key) => box.read(key);

  void setValue(String key, T value) => box.write(key, value);
}

extension StorageExtension<T> on String {
  T get getValue => StorageService().getValue(this);
  void setStringValue(String value) => StorageService().setValue(this, value);
}
