import 'package:appandromeda/services/db.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:appandromeda/services/customer.dart';

import 'package:appandromeda/models/response.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    //final ApiRepository _apiRepository = ApiRepository();
    final CustomerService customerService = CustomerService();

    on<GetFavoriteList>((event, emit) async {
      emit(FavoriteLoading());

      try {
        final mList = await customerService.getFavorites();

        if (mList.result == 'ok') {
          emit(FavoriteLoaded(mList));
        }

        if (mList.result == 'excep') {
          emit(const FavoriteErrorSession());
        }

        if (mList.result == 'fail') {
          emit(const FavoriteLoadedEmpty());
        }
      } on NetworkError {
        emit(const FavoriteError(
            "Failed to fetch data. is your device online?"));
      }
    });

    on<DeleteFavorite>((event, emit) async {
      //emit(FavoriteLoading());
      try {
        await customerService.deleteFavorite(event.id).then((value) async {
          await serviceDB.instance
              .deleteRecord('favorites', 'id', int.parse(event.id));

          // emit(FavoriteLoading());
          final mList = await customerService.getFavorites();

          if (mList.result == 'ok') {
            emit(FavoriteLoaded(mList));
          }

          if (mList.result == 'excep') {
            emit(const FavoriteErrorSession());
          }

          if (mList.result == 'fail') {
            emit(const FavoriteLoadedEmpty());
          }
        });
      } on NetworkError {
        emit(const FavoriteError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
