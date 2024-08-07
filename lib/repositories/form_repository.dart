import 'dart:io';

import 'package:polaris_test/services/form/form_service.dart';
import 'package:polaris_test/utils/keys_constant.dart';

class FormRepository {
  final FormService formService = FormService();

  // Singleton Implementation
  factory FormRepository() => _sharedReference;
  static final _sharedReference = FormRepository._sharedInstance();
  FormRepository._sharedInstance();

  Future<Map<String, dynamic>> fetchForm() async {
    return await formService.fetchForm();
  }

  Future<void> submitForm({
    required List<Map<String, dynamic>> formData,
    required List<Map<String, dynamic>> imageDetails,
  }) async {
    await formService.pushFormData(formData);
    for (Map<String, dynamic> map in imageDetails) {
      final List<String> images = map[keyMetaInfo][keyAppImagesPathsList] ?? [];
      final String savingFolder = map[keyMetaInfo][keySavingFolder];
      for (String imagePath in images) {
        await formService.uploadImage(
          imageFile: File(imagePath),
          savingFolder: savingFolder,
        );
      }
    }
  }
}
