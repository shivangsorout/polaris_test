import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polaris_test/helpers/custom_widgets/text_label.dart';
import 'package:polaris_test/models/form_field.dart';
import 'package:polaris_test/models/meta_info/capture_image_meta_info.dart';

class CaptureImageFormField extends FormField<List<String>> {
  final bool isMandatory;
  final int numberOfImages;
  final FormFieldData formField;
  final int index;
  final void Function(FormFieldData, int) addImages;

  CaptureImageFormField({
    super.key,
    required this.isMandatory,
    required this.numberOfImages,
    required this.formField,
    required this.index,
    required this.addImages,
  }) : super(
          initialValue:
              (formField.metaInfo as CaptureImageMetaInfo).imagesPathsList,
          validator: (value) {
            if (isMandatory &&
                (value == null || value.length < numberOfImages)) {
              return 'You must capture ${numberOfImages == 1 ? '1 image' : '$numberOfImages images'}!';
            } else {
              return null;
            }
          },
          builder: (FormFieldState<List<String>> state) {
            return _CaptureImageFormFieldContent(
              state: state,
              isMandatory: isMandatory,
              numberOfImages: numberOfImages,
              formField: formField,
              index: index,
              addImages: addImages,
            );
          },
        );

  @override
  FormFieldState<List<String>> createState() => FormFieldState<List<String>>();
}

class _CaptureImageFormFieldContent extends StatefulWidget {
  final FormFieldState<List<String>> state;
  final bool isMandatory;
  final int numberOfImages;
  final FormFieldData formField;
  final int index;
  final void Function(FormFieldData, int) addImages;

  const _CaptureImageFormFieldContent({
    required this.state,
    required this.isMandatory,
    required this.numberOfImages,
    required this.formField,
    required this.index,
    required this.addImages,
  });

  @override
  _CaptureImageFormFieldContentState createState() =>
      _CaptureImageFormFieldContentState();
}

class _CaptureImageFormFieldContentState
    extends State<_CaptureImageFormFieldContent>
    with AutomaticKeepAliveClientMixin {
  List<String> imagePaths = [];

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imagePaths.add(pickedFile.path);
        _validate();
      });
    }
    final metaInfo = widget.formField.metaInfo as CaptureImageMetaInfo;
    final CaptureImageMetaInfo updatedMetaInfo = CaptureImageMetaInfo(
      label: metaInfo.label,
      isMandatory: widget.isMandatory,
      numberOfImagesToCapture: widget.numberOfImages,
      savingFolder: metaInfo.savingFolder,
      imagesPathsList: imagePaths,
    );
    final updatedFormField = FormFieldData(
      componentType: widget.formField.componentType,
      metaInfo: updatedMetaInfo,
    );
    widget.addImages(
      updatedFormField,
      widget.index,
    );
  }

  void _validate() {
    setState(() {
      widget.state.didChange(imagePaths);
    });
  }

  @override
  void initState() {
    final metaInfo = widget.formField.metaInfo as CaptureImageMetaInfo;
    if (metaInfo.imagesPathsList.isNotEmpty) {
      setState(() {
        imagePaths = metaInfo.imagesPathsList;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TextLabel(
      height: 5,
      labelText: widget.formField.metaInfo.label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(widget.numberOfImages, (index) {
                    if (index < imagePaths.length) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(imagePaths[index]),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  imagePaths.removeAt(index);
                                  _validate();
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return MaterialButton(
                        clipBehavior: Clip.hardEdge,
                        padding: const EdgeInsets.all(0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        onPressed: _captureImage,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.fromBorderSide(BorderSide(
                              width: 1,
                              color: Colors.grey,
                            )),
                          ),
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
          if (widget.state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.state.errorText!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
