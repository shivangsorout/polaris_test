import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:polaris_test/models/meta_info/radio_group_meta_info.dart';
import 'package:polaris_test/services/local_storage/local_form_service.dart';
import 'package:polaris_test/utils/dialogs/error_dialog.dart';
import 'package:polaris_test/utils/dialogs/success_dialog.dart';
import 'package:polaris_test/utils/keys_constant.dart';
import 'dart:developer' as devtools show log;

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
    FormFieldData formField,
  ) {
    if (!_formResponses.containsKey(index)) {
      _formResponses[index] = {};
    }
    _formResponses[index] = formField.toJson();
    devtools.log(_formResponses.toString());
  }

  List<Map<String, dynamic>> _getFormValuesAsList() {
    return _formResponses.values.toList();
  }

  void addImages(
    FormFieldData formField,
    int index,
  ) {
    if (!_formImageResponses.containsKey(index)) {
      _formImageResponses[index] = {};
    }
    _formImageResponses[index] = formField.toJson();
    devtools.log(_formImageResponses.toString());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FormsBloc, FormsState>(
      listener: (context, state) {
        if (state is FormErrorState) {
          showErrorDialog(context, state.message);
        } else if (state.successMessage.isNotEmpty) {
          showSuccessDialog(context, state.successMessage);
          _formResponses.clear();
          _formImageResponses.clear();
        }
      },
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
          final cState = state is FormLoadedState ? state : state;
          if (cState is FormLoadedState) {
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
                          final formField = cState.formFieldList[index];
                          final formLength = cState.formFieldList.length;
                          final entriesLength = _formImageResponses.length +
                              _formResponses.length;
                          final isFullLength = entriesLength == formLength;
                          if (!isFullLength &&
                              formField.componentType == keyCaptureImages) {
                            addImages(formField, index);
                          } else if (!isFullLength) {
                            _onFieldChanged(index, formField);
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 13.0),
                            child: _buildWidget(
                                cState.formFieldList[index], index),
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
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final connectivityResult =
                                        await (Connectivity()
                                            .checkConnectivity());
                                    if (connectivityResult.contains(
                                            ConnectivityResult.mobile) ||
                                        connectivityResult.contains(
                                            ConnectivityResult.wifi)) {
                                      if (context.mounted) {
                                        context
                                            .read<FormsBloc>()
                                            .add(SubmitFormDataEvent(
                                              formData: _formResponses.values
                                                  .toList(),
                                              imageDetails: _formImageResponses
                                                  .values
                                                  .toList(),
                                            ));
                                      }
                                    } else {
                                      if (context.mounted) {
                                        showErrorDialog(
                                          context,
                                          'Internet is not available! Data will be stored locally and whenever internet is available, data will be pushed!',
                                        );
                                        List<Map<String, dynamic>> fields =
                                            List.generate(
                                                cState.formFieldList.length,
                                                (index) => {});
                                        if (_formResponses.isNotEmpty) {
                                          _formResponses.forEach(
                                            (key, value) {
                                              fields.removeAt(key);
                                              fields.insert(key, value);
                                            },
                                          );
                                        }
                                        if (_formImageResponses.isNotEmpty) {
                                          _formImageResponses.forEach(
                                            (key, value) {
                                              fields.removeAt(key);
                                              fields.insert(key, value);
                                            },
                                          );
                                        }
                                        await LocalFormService()
                                            .saveFormData(keyFields, fields);
                                        await LocalFormService().saveFormData(
                                            keyFormName, cState.formName);
                                      }
                                    }
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
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Disconnected'),
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildWidget(FormFieldData field, int index) {
    switch (field.componentType) {
      case keyEditText:
        return FormTextField(
          index: index,
          formField: field,
          onFieldChanged: _onFieldChanged,
        );
      case keyCheckBoxes:
        final metaInfo = field.metaInfo as CheckboxMetaInfo;
        return CheckboxesFormField(
          index: index,
          isMandatory: metaInfo.isMandatory,
          formField: field,
          onFieldChanged: _onFieldChanged,
        );
      case keyDropDown:
        return DropdownWidgetFormField(
          index: index,
          formField: field,
          onFieldChanged: _onFieldChanged,
        );
      case keyRadioGroup:
        final metaInfo = field.metaInfo as RadioGroupMetaInfo;
        return RadioGroupFormField(
          index: index,
          isMandatory: metaInfo.isMandatory,
          formField: field,
          onFieldChanged: _onFieldChanged,
        );
      case keyCaptureImages:
        final metaInfo = field.metaInfo as CaptureImageMetaInfo;
        return CaptureImageFormField(
          index: index,
          addImages: addImages,
          isMandatory: metaInfo.isMandatory,
          numberOfImages: metaInfo.numberOfImagesToCapture,
          formField: field,
        );
      default:
        throw Exception('Unknown componentType found!');
    }
  }
}
