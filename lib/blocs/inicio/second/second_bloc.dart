import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:appandromeda/services/store.dart';
import 'package:appandromeda/models/response.dart';

part 'second_event.dart';
part 'second_state.dart';

class SecondBloc extends Bloc<SecondEvent, SecondState> {
  SecondBloc() : super(SecondInitial()) {
    //final ApiRepository _apiRepository = ApiRepository();
    final StoreService storeService = StoreService();

    on<GetSecondList>((event, emit) async {
      try {
        emit(SecondLoading());
        final mList = await storeService.secondSection();
        if (mList.error != null) {
          emit(SecondError(mList.error));
        } else {
          emit(SecondLoaded(mList));
        }
      } on NetworkError {
        emit(const SecondError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
