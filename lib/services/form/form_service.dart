import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:polaris_test/models/form_field.dart';
import 'dart:io';
import 'package:polaris_test/services/aws/s3_service.dart';
import 'package:polaris_test/utils/keys_constant.dart';

class FormService {
  static const String fetchFormUrl =
      'https://chatbot-api.grampower.com/flutter-assignment';
  static const String pushDataUrl =
      'https://chatbot-api.grampower.com/flutter-assignment/push';
  final S3Service s3Service = S3Service();

  Future<Map<String, dynamic>> fetchForm() async {
    final response = await http.get(Uri.parse(fetchFormUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> resultMap = {};
      final map = json.decode(response.body) as Map<String, dynamic>;
      resultMap[keyFormName] = map[keyFormName];
      resultMap[keyFields] = (map[keyFields] as List)
          .map((fieldJson) => FormField.fromJson(fieldJson))
          .toList();
      return resultMap;
    } else {
      throw Exception('Failed to load form');
    }
  }

  Future<void> pushFormData(List<Map<String, dynamic>> formData) async {
    final response = await http.post(
      Uri.parse(pushDataUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'data': formData}),
    );

    if (!(response.statusCode >= 200 && response.statusCode <= 299)) {
      throw Exception('Failed to push form data');
    }
  }

  Future<void> uploadImage(
    File imageFile,
    String candidateName,
    String savingFolder,
  ) async {
    await s3Service.uploadImage(
      image: imageFile,
      candidateName: candidateName,
      savingFolder: savingFolder,
    );
  }
}
