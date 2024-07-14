import 'package:flutter/material.dart';

@immutable
abstract class FormsEvent {}

class LoadFormEvent extends FormsEvent {
  LoadFormEvent();
}

class SubmitFormDataEvent extends FormsEvent {
  final List<Map<String, dynamic>> formData;
  final List<Map<String, dynamic>> imageDetails;

  SubmitFormDataEvent({
    required this.formData,
    required this.imageDetails,
  });
}
