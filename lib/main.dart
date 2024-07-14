import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_test/bloc/form_bloc.dart';
import 'package:polaris_test/bloc/form_event.dart';
import 'package:polaris_test/repositories/form_repository.dart';
import 'package:polaris_test/views/home_view.dart';
import 'package:polaris_test/services/aws/s3_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureAmplify();
  runApp(const MyApp());
}

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
