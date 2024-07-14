import 'dart:io';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:polaris_test/amplifyconfiguration.dart';
import 'dart:developer' as devtools show log;

void configureAmplify() async {
  final storage = AmplifyStorageS3();
  AmplifyAuthCognito auth = AmplifyAuthCognito();
  await Amplify.addPlugins([auth, storage]);

  try {
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    devtools.log('An error occurred while configuring Amplify: $e');
  }
}

// S3Service class for handling image uploads to S3
class S3Service {
  Future<void> uploadImage({
    required File image,
    required String candidateName,
    required String savingFolder,
  }) async {
    final key =
        'tasks/$candidateName/$savingFolder/${image.path.split('/').last}';
    try {
      final result = Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(image.path),
        path: StoragePath.fromString('public/$key'),
      );
      await result.result.then(
        (value) {
          devtools.log('Successfully uploaded image: ${result.operationId}');
        },
      );
    } catch (e) {
      devtools.log('Error uploading image: $e');
    }
  }
}
