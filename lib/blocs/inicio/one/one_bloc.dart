import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:appandromeda/services/store.dart';
import 'package:appandromeda/models/response.dart';

part 'one_event.dart';
part 'one_state.dart';

class OneBloc extends Bloc<OneEvent, OneState> {
  OneBloc() : super(OneInitial()) {
    //final ApiRepository _apiRepository = ApiRepository();
    final StoreService storeService = StoreService();

    on<GetOneList>((event, emit) async {
      emit(OneLoading());

      try {
        final mList = await storeService.firstSection();

        if (mList.result == 'ok') {
          emit(OneLoaded(mList));
        }

        if (mList.result == 'excep') {
          emit(const OneErrorSession());
        }

        if (mList.result == 'fail') {
          emit(const OneLoadedEmpty());
        }
      } on NetworkError {
        emit(const OneError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
