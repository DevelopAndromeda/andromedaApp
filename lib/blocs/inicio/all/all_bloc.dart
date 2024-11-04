import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:appandromeda/services/store.dart';
import 'package:appandromeda/models/response.dart';

part 'all_event.dart';
part 'all_state.dart';

class AllBloc extends Bloc<AllEvent, AllState> {
  AllBloc() : super(AllInitial()) {
    //final ApiRepository _apiRepository = ApiRepository();
    final StoreService storeService = StoreService();

    on<GetAllList>((event, emit) async {
      try {
        emit(AllLoading());
        final mList = await storeService.allRestaurants();
        if (mList.error != null) {
          emit(AllError(mList.error));
        } else {
          emit(AllLoaded(mList));
        }
      } on NetworkError {
        emit(const AllError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
