Map<String, dynamic> convertToStringDynamicMap(
    Map<dynamic, dynamic> originalMap) {
  final Map<String, dynamic> newMap = {};

  originalMap.forEach((key, value) {
    if (key is String) {
      newMap[key] = value;
    } else {
      throw Exception('Key $key is not a String');
    }
  });

  return newMap;
}

List<Map<String, dynamic>> convertToListOfMap(List<dynamic> originalList) {
  List<Map<String, dynamic>> newList = [];

  for (var item in originalList) {
    if (item is Map<String, dynamic>) {
      newList.add(item);
    } else if (item is Map<dynamic, dynamic>) {
      final newMap = convertToStringDynamicMap(item);
      newList.add(newMap);
    } else {
      throw Exception('Item $item is not a Map<String, dynamic>');
    }
  }

  return newList;
}
