import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:andromeda/services/store.dart';
import 'package:andromeda/models/response.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreInitial()) {
    //final ApiRepository _apiRepository = ApiRepository();
    final StoreService storeService = StoreService();

    on<GetStoresList>((event, emit) async {
      try {
        emit(StoreLoading());
        final mList = await storeService.myStores();

        if (mList.error != null) {
          emit(StoreError(mList.error));
        }

        emit(StoreLoaded(mList));
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
