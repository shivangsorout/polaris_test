import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polaris_test/helpers/custom_widgets/text_label.dart';

class CaptureImageFormField extends FormField<List<File>> {
  final String labelText;
  final bool isMandatory;
  final int numberOfImages;
  final String savingFolder;
  final int index;
  final void Function(List<File>, String, int) addImages;

  CaptureImageFormField({
    super.key,
    required this.labelText,
    required this.isMandatory,
    required this.numberOfImages,
    required this.savingFolder,
    required this.index,
    required this.addImages,
  }) : super(
          validator: (value) {
            if (isMandatory &&
                (value == null || value.length < numberOfImages)) {
              return 'You must capture ${numberOfImages == 1 ? '1 image' : '$numberOfImages images'}!';
            } else {
              return null;
            }
          },
          builder: (FormFieldState<List<File>> state) {
            return _CaptureImageFormFieldContent(
              state: state,
              labelText: labelText,
              isMandatory: isMandatory,
              numberOfImages: numberOfImages,
              savingFolder: savingFolder,
              index: index,
              addImages: addImages,
            );
          },
        );

  @override
  FormFieldState<List<File>> createState() => FormFieldState<List<File>>();
}

class _CaptureImageFormFieldContent extends StatefulWidget {
  final FormFieldState<List<File>> state;
  final String labelText;
  final bool isMandatory;
  final int numberOfImages;
  final String savingFolder;
  final int index;
  final void Function(List<File>, String, int) addImages;

  const _CaptureImageFormFieldContent({
    required this.state,
    required this.labelText,
    required this.isMandatory,
    required this.numberOfImages,
    required this.savingFolder,
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
  final List<File> _imageFiles = [];

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
        _validate();
      });
    }
    widget.addImages(
      _imageFiles,
      widget.savingFolder,
      widget.index,
    );
  }

  void _validate() {
    setState(() {
      widget.state.didChange(_imageFiles);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TextLabel(
      height: 5,
      labelText: widget.labelText,
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
                    if (index < _imageFiles.length) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _imageFiles[index],
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
                                  _imageFiles.removeAt(index);
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
