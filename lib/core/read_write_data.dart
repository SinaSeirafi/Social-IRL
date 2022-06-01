import 'package:shared_preferences/shared_preferences.dart';

ReadWriteData rw = ReadWriteData.instance;

class ReadWriteData {
  static final ReadWriteData _readWriteData = ReadWriteData();
  static ReadWriteData get instance => _readWriteData;

  Future<dynamic> read(String key, String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Object? response;

    try {
      switch (type) {
        case 'String':
          response = prefs.getString(key);
          break;

        case 'bool':
          response = prefs.getBool(key);
          break;

        case 'int':
          response = prefs.getInt(key);
          break;

        case 'double':
          response = prefs.getDouble(key);
          break;

        default:
      }
    } catch (e) {
      rethrow;
    }

    return response;
  }

  Future<bool> write(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (value is String) {
        return await prefs.setString(key, value);
      } else if (value is bool) {
        return await prefs.setBool(key, value);
      } else if (value is int) {
        return await prefs.setInt(key, value);
      } else if (value is double) {
        return await prefs.setDouble(key, value);
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  Future<bool> removeData(var key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
