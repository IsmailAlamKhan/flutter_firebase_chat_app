import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  final box = GetStorage();
// Create storage
  final storage = FlutterSecureStorage();

// Read value
  Future<String> read(String key) async => await storage.read(key: key);

// Read all values
  Future<Map<String, String>> get allValues async => await storage.readAll();

// Delete value
  Future<void> delete(String key) async => await storage.delete(key: key);

// Delete all
  Future<void> deleteAll() async => await storage.deleteAll();

// Write value
  Future<void> write(String key, String value) async => await storage.write(
        key: key,
        value: value,
      );
}

extension StorageExtension<T> on String {
  T get getValue => StorageService().box.read(this);
  void setStringValue(String value) => StorageService().box.write(this, value);
}
