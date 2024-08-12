import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:andromeda/services/store.dart';
import 'package:andromeda/models/response.dart';

part 'one_event.dart';
part 'one_state.dart';

class OneBloc extends Bloc<OneEvent, OneState> {
  OneBloc() : super(OneInitial()) {
    //final ApiRepository _apiRepository = ApiRepository();
    final StoreService storeService = StoreService();

    on<GetOneList>((event, emit) async {
      try {
        emit(OneLoading());
        final mList = await storeService.firstSection();
        if (mList.error != null) {
          emit(OneError(mList.error));
        }
        emit(OneLoaded(mList));
      } on NetworkError {
        emit(const OneError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
