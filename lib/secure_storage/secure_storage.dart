import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// This class contains the file that creates the secure storage on the user's device.
class SecureStorage{
  final _storage = FlutterSecureStorage();

  /// Writes data to a secure file on the device.
  ///
  /// [key], the key used to access the data.
  /// [value], the data returned by the key.
  Future writeSecureData(String key, String value) async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }

  /// Reads data from a secure file on the device.
  ///
  /// [value], the data returned by the key.
   Future readSecureData(String key) async{
    var readData = await _storage.read(key: key);
    return readData;
  }

  /// Deletes the specified data from the device.
  ///
  /// [key], the key used to access the data.
  Future deleteSecureData(String key) async {
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }
}
