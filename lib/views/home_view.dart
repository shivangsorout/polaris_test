import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:polaris_test/services/aws/s3_service.dart';
import 'package:polaris_test/utils/keys_constant.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Map<int, Map<String, dynamic>> _formResponses = {};
  final Map<int, Map<String, dynamic>> _formImageResponses = {};
  final _formKey = GlobalKey<FormState>();

  void _onFieldChanged(
    int index,
    String key,
    dynamic value,
    String label,
  ) {
    setState(() {
      if (!_formResponses.containsKey(index)) {
        _formResponses[index] = {};
      }
      _formResponses[index]![key] = value;
      _formResponses[index]![keyLabel] = label;
    });
  }

  List<Map<String, dynamic>> _getFormValuesAsList() {
    return _formResponses.values.toList();
  }

  void addImages(
    List<File> images,
    String candidateName,
    String savingFolder,
    int index,
  ) {
    setState(() {
      if (!_formImageResponses.containsKey(index)) {
        _formImageResponses[index] = {};
      }
      _formImageResponses[index]![keyAppImages] = images;
      _formImageResponses[index]![keyAppCandidateName] = candidateName;
      _formImageResponses[index]![keyAppSavingFolder] = savingFolder;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polaris Test'),
      ),
      body: Form(
        key: _formKey,
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              // MaterialButton(
              //   onPressed: () {
              //     if (_formKey.currentState!.validate()) {
              //       print(_formResponses);
              //     }
              //     List<Map<String, dynamic>> imageDetails =
              //         _formImageResponses.values.toList();
              //     for (Map<String, dynamic> map in imageDetails) {
              //       final List<File> images = map[keyAppImages];
              //       final String localCandidateName = map[keyAppCandidateName];
              //       final String localSavingFolder = map[keyAppSavingFolder];
              //       for (File file in images) {
              //         S3Service().uploadImage(
              //           candidateName: localCandidateName,
              //           image: file,
              //           savingFolder: localSavingFolder,
              //         );
              //       }
              //     }
              //   },
              //   child: Text('Hello'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
