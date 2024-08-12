import 'package:andromeda/services/db.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:andromeda/services/customer.dart';

import 'package:andromeda/models/response.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    //final ApiRepository _apiRepository = ApiRepository();
    final CustomerService customerService = CustomerService();

    on<GetFavoriteList>((event, emit) async {
      try {
        emit(FavoriteLoading());
        final mList = await customerService.getFavorites();
        if (mList.error != null) {
          emit(FavoriteError(mList.error));
        }
        emit(FavoriteLoaded(mList));
      } on NetworkError {
        emit(const FavoriteError(
            "Failed to fetch data. is your device online?"));
      }
    });

    on<DeleteFavorite>((event, emit) async {
      try {
        await customerService.deleteFavorite(event.id).then((value) async {
          await serviceDB.instance
              .deleteRecord('favorites', 'id', int.parse(event.id));

          emit(FavoriteLoading());
          final mList = await customerService.getFavorites();

          if (mList.error != null) {
            emit(FavoriteError(mList.error));
          }

          emit(FavoriteLoaded(mList));
        });
      } on NetworkError {
        emit(const FavoriteError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
