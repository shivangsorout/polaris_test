import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:polaris_test/bloc/form_bloc.dart';
import 'package:polaris_test/bloc/form_event.dart';
import 'package:polaris_test/repositories/form_repository.dart';
import 'package:polaris_test/services/local_storage/local_form_service.dart';
import 'package:polaris_test/utils/keys_constant.dart';
import 'package:polaris_test/utils/utility.dart';
import 'package:polaris_test/views/home_view.dart';
import 'package:polaris_test/services/aws/s3_service.dart';
import 'dart:developer' as devtools show log;

import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializingComponents();
  Workmanager().initialize(
    _callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager().registerPeriodicTask(
    '1',
    'internetSync',
    initialDelay: const Duration(minutes: 4), // Set time accordingly
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
  );
  // Used this for testing
  // Workmanager().registerOneOffTask(
  //   '2',
  //   'internetSyncing',
  //   initialDelay: const Duration(seconds: 10),
  //   constraints: Constraints(
  //     networkType: NetworkType.not_required,
  //     requiresBatteryNotLow: false,
  //     requiresCharging: false,
  //     requiresDeviceIdle: false,
  //     requiresStorageNotLow: false,
  //   ),
  // );
  runApp(const MyApp());
}

Future<void> initializingComponents() async {
  configureAmplify();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await LocalFormService().init();
}

// Work Manager functions
void _callbackDispatcher() async {
  Workmanager().executeTask((_, __) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return synchronizeData();
    }
    return Future.value(false);
  });
}

Future<bool> synchronizeData() async {
  try {
    await initializingComponents();
    var data = LocalFormService().getAllFormData();
    if (data.isNotEmpty) {
      FormRepository formRepository = FormRepository();
      List<Map<String, dynamic>> formData = [];
      List<Map<String, dynamic>> imageDetails = [];
      convertToListOfMap(data[keyFields]).forEach(
        (element) => element[keyComponentType] == keyCaptureImages
            ? imageDetails.add(element)
            : formData.add(element),
      );
      await formRepository.submitForm(
          formData: formData, imageDetails: imageDetails);
      devtools.log('Data uploaded successfully!');
      LocalFormService().clearFormData();
      return Future.value(true);
    }
  } catch (error) {
    devtools.log('Error: $error');
    return Future.error(error);
  }
  return Future.value(false);
}

// Work Manager functions end ---------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polaris Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[100],
          elevation: 10,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: BlocProvider(
        create: (context) => FormsBloc(FormRepository())..add(LoadFormEvent()),
        child: const HomeView(),
      ),
    );
  }
}
