import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:appandromeda/services/store.dart';
import 'package:appandromeda/models/response.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreInitial()) {
    //final ApiRepository _apiRepository = ApiRepository();
    final StoreService storeService = StoreService();

    on<GetStoresList>((event, emit) async {
      emit(StoreLoading());
      try {
        final mList = await storeService.myStores();

        if (mList.result == 'ok') {
          emit(StoreLoaded(mList));
        }

        if (mList.result == 'excep') {
          emit(const StoreErrorSession());
        }

        if (mList.result == 'fail') {
          emit(const StoreLoadedEmpty());
        }
        /*if (mList.error != null) {
          emit(StoreError(mList.error));
        } else {
          emit(StoreLoaded(mList));
        }*/
      } on NetworkError {
        emit(const StoreError("Failed to fetch data. is your device online?"));
      }
    });

    on<GetStoreById>((event, emit) async {
      try {
        emit(StoreLoading());
        final mList = await storeService.getById(event.id);

        if (mList.error != null) {
          emit(StoreError(mList.error));
        }

        emit(StoreLoaded(mList));
      } on NetworkError {
        emit(const StoreError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
