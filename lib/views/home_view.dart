import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_test/bloc/form_bloc.dart';
import 'package:polaris_test/bloc/form_event.dart';
import 'package:polaris_test/bloc/form_state.dart';
import 'package:polaris_test/helpers/custom_widgets/capture_image_widget.dart';
import 'package:polaris_test/helpers/custom_widgets/checkboxes_widget.dart';
import 'package:polaris_test/helpers/custom_widgets/dropdown_widget.dart';
import 'package:polaris_test/helpers/custom_widgets/form_text_field.dart';
import 'package:polaris_test/helpers/custom_widgets/radio_group_widget.dart';
import 'package:polaris_test/models/form_field.dart';
import 'package:polaris_test/models/meta_info/capture_image_meta_info.dart';
import 'package:polaris_test/models/meta_info/checkbox_meta_info.dart';
import 'package:polaris_test/models/meta_info/dropdown_meta_info.dart';
import 'package:polaris_test/models/meta_info/edit_text_meta_info.dart';
import 'package:polaris_test/models/meta_info/radio_group_meta_info.dart';
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
    String savingFolder,
    int index,
  ) {
    setState(() {
      if (!_formImageResponses.containsKey(index)) {
        _formImageResponses[index] = {};
      }
      _formImageResponses[index]![keyAppImages] = images;
      _formImageResponses[index]![keyAppSavingFolder] = savingFolder;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final cState = state as FormLoadedState;
          return Scaffold(
            appBar: AppBar(
              title: Text(cState.formName),
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(12.0),
                      itemCount: cState.formFieldList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13.0),
                          child:
                              _buildWidget(cState.formFieldList[index], index),
                        );
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: MaterialButton(
                              color: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<FormsBloc>()
                                      .add(SubmitFormDataEvent(
                                        formData:
                                            _formResponses.values.toList(),
                                        imageDetails:
                                            _formImageResponses.values.toList(),
                                      ));
                                }
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildWidget(FormFieldData field, int index) {
    switch (field.componentType) {
      case keyEditText:
        final metaInfo = field.metaInfo as EditTextMetaInfo;
        return FormTextField(
          index: index,
          inputType: metaInfo.componentInputType,
          isMandatory: metaInfo.isMandatory,
          labelText: metaInfo.label,
          onFieldChanged: _onFieldChanged,
        );
      case keyCheckBoxes:
        final metaInfo = field.metaInfo as CheckboxMetaInfo;
        return CheckboxesFormField(
          index: index,
          isMandatory: metaInfo.isMandatory,
          labelText: metaInfo.label,
          options: metaInfo.options,
          onFieldChanged: _onFieldChanged,
        );
      case keyDropDown:
        final metaInfo = field.metaInfo as DropdownMetaInfo;
        return DropdownWidgetFormField(
          index: index,
          isMandatory: metaInfo.isMandatory,
          labelText: metaInfo.label,
          options: metaInfo.options,
          onFieldChanged: _onFieldChanged,
        );
      case keyRadioGroup:
        final metaInfo = field.metaInfo as RadioGroupMetaInfo;
        return RadioGroupFormField(
          index: index,
          isMandatory: metaInfo.isMandatory,
          labelText: metaInfo.label,
          options: metaInfo.options,
          onFieldChanged: _onFieldChanged,
        );
      case keyCaptureImages:
        final metaInfo = field.metaInfo as CaptureImageMetaInfo;
        return CaptureImageFormField(
          index: index,
          addImages: addImages,
          isMandatory: metaInfo.isMandatory,
          labelText: metaInfo.label,
          numberOfImages: metaInfo.numberOfImagesToCapture,
          savingFolder: metaInfo.savingFolder,
        );
      default:
        throw Exception('Unknown componentType found!');
    }
  }
}
