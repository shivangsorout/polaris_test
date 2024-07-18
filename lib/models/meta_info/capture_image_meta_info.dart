import 'package:polaris_test/utils/keys_constant.dart';
import 'package:polaris_test/models/meta_info/abstract_meta_info.dart';

class CaptureImageMetaInfo extends MetaInfo {
  final int numberOfImagesToCapture;
  final String savingFolder;
  final List<String> imagesPathsList;

  const CaptureImageMetaInfo({
    required super.label,
    required super.isMandatory,
    required this.numberOfImagesToCapture,
    required this.savingFolder,
    this.imagesPathsList = const [],
  });

  CaptureImageMetaInfo.fromJson(Map<String, dynamic> map)
      : numberOfImagesToCapture = map[keyNumberOfImages],
        savingFolder = map[keySavingFolder],
        imagesPathsList = map.containsKey(keyAppImagesPathsList)
            ? map[keyAppImagesPathsList]
            : [],
        super(
          isMandatory: map[keyMandatory] == 'yes',
          label: map[keyLabel],
        );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> resultMap = {};
    resultMap[keyLabel] = label;
    resultMap[keyMandatory] = isMandatory ? 'yes' : 'no';
    resultMap[keyNumberOfImages] = numberOfImagesToCapture;
    resultMap[keySavingFolder] = savingFolder;
    if (imagesPathsList.isNotEmpty) {
      resultMap[keyAppImagesPathsList] = imagesPathsList;
    }
    return resultMap;
  }
}
