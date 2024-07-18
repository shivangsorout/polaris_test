import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_test/bloc/form_event.dart';
import 'package:polaris_test/bloc/form_state.dart';
import 'package:polaris_test/models/form_field.dart';
import 'package:polaris_test/repositories/form_repository.dart';
import 'package:polaris_test/services/local_storage/local_form_service.dart';
import 'package:polaris_test/utils/keys_constant.dart';
import 'package:polaris_test/utils/utility.dart';

class FormsBloc extends Bloc<FormsEvent, FormsState> {
  final FormRepository formRepository;

  FormsBloc(this.formRepository) : super(const FormInitialState()) {
    on<LoadFormEvent>((event, emit) async {
      emit(FormInitialState(
        isLoading: true,
        formName: state.formName,
      ));
      try {
        Map<String, dynamic> formData = {};
        formData = LocalFormService().getAllFormData();
        if (formData.isEmpty) {
          formData = await formRepository.fetchForm();
          emit(
            FormLoadedState(
              formFieldList: formData[keyFields],
              formName: formData[keyFormName],
              isLoading: false,
            ),
          );
        } else {
          emit(
            FormLoadedState(
              formFieldList: (formData[keyFields] as List).map((map) {
                final newMap = convertToStringDynamicMap(map);
                return FormFieldData.fromJson(newMap);
              }).toList(),
              formName: formData[keyFormName],
              isLoading: false,
            ),
          );
        }
      } catch (error) {
        emit(FormErrorState(
          message: error.toString(),
          formName: state.formName,
        ));
      }
    });

    on<SubmitFormDataEvent>((event, emit) async {
      emit(
        FormLoadedState(
          formFieldList: state is FormLoadedState
              ? (state as FormLoadedState).formFieldList
              : [],
          formName: state.formName,
          isLoading: true,
        ),
      );
      try {
        final formData = event.formData;
        final imageDetails = event.imageDetails;

        await formRepository.submitForm(
          formData: formData,
          imageDetails: imageDetails,
        );

        await LocalFormService().clearFormData();
        final formDetails = await formRepository.fetchForm();
        emit(FormLoadedState(
          formFieldList: formDetails[keyFields],
          formName: state.formName,
          isLoading: false,
          successMessage: 'Data and Images were submitted successfully!',
        ));
      } catch (error) {
        emit(FormErrorState(
          message: error.toString(),
          formName: state.formName,
        ));
      }
    });
  }
}
