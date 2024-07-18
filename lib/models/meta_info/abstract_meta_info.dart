import 'package:flutter/material.dart';

@immutable
abstract class MetaInfo {
  final String label;
  final bool isMandatory;

  const MetaInfo({
    required this.label,
    required this.isMandatory,
  });

  Map<String, dynamic> toJson();
}
