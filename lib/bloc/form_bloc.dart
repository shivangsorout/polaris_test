import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_test/bloc/form_event.dart';
import 'package:polaris_test/bloc/form_state.dart';
import 'package:polaris_test/repositories/form_repository.dart';
import 'package:polaris_test/utils/keys_constant.dart';

class FormsBloc extends Bloc<FormsEvent, FormsState> {
  final FormRepository formRepository;

  FormsBloc(this.formRepository) : super(const FormInitialState()) {
    on<LoadFormEvent>((event, emit) async {
      emit(FormInitialState(
        isLoading: true,
        formName: state.formName,
      ));
      try {
        final formData = await formRepository.fetchForm();
        emit(
          FormLoadedState(
            formFieldList: formData[keyFields],
            formName: formData[keyFormName],
            isLoading: false,
          ),
        );
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

        emit(FormLoadedState(
          formFieldList: (state as FormLoadedState).formFieldList,
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
