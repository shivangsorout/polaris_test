import 'package:hive/hive.dart';

class LocalFormService {
  final String boxName = "form_data";

  //singleton implementation
  factory LocalFormService() => _sharedReference;
  static final _sharedReference = LocalFormService._sharedInstance();
  LocalFormService._sharedInstance();

  Future<void> init() async {
    await Hive.openBox(boxName);
  }

  Future<void> saveFormData(String key, dynamic data) async {
    var box = Hive.box(boxName);
    await box.put(key, data);
  }

  Map<String, dynamic>? getFormData(String key) {
    var box = Hive.box(boxName);
    return box.get(key);
  }

  Map<String, dynamic> getAllFormData() {
    var box = Hive.box(boxName);
    return Map<String, dynamic>.from(box.toMap());
  }

  Future<void> clearFormData() async {
    var box = Hive.box(boxName);
    await box.clear();
  }

  Future<void> deleteFormData(String key) async {
    var box = Hive.box(boxName);
    await box.delete(key);
  }
}
