import 'package:flutter/material.dart';
import 'package:polaris_test/models/form_field.dart';

@immutable
abstract class FormsState {
  final String formName;
  final bool isLoading;
  final String successMessage;

  const FormsState({
    required this.formName,
    this.isLoading = false,
    this.successMessage = '',
  });
}

class FormInitialState extends FormsState {
  const FormInitialState({
    super.formName = '',
    super.isLoading = true,
    super.successMessage = '',
  });
}

class FormLoadedState extends FormsState {
  final List<FormFieldData> formFieldList;
  const FormLoadedState({
    required this.formFieldList,
    required super.formName,
    super.isLoading = false,
    super.successMessage = '',
  });
}

class FormErrorState extends FormsState {
  final String message;
  const FormErrorState({
    required this.message,
    super.formName = '',
  });
}
