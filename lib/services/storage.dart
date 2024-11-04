import 'package:localstorage/localstorage.dart';

class StorageService {
  Future<void> saveToStorage(key, data) async {
    localStorage.setItem(key, data);
  }

  Future<dynamic> getToStorage(key) async {
    return localStorage.getItem(key);
  }

  Future<void> destroySession() async {
    localStorage.clear();
  }
}
