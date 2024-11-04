import 'package:appandromeda/models/paises.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appandromeda/services/catalog.dart';
import 'package:appandromeda/utilities/constanst.dart';

abstract class CatalogState {}

class InitializeState extends CatalogState {}

class CatalogLoadingState extends CatalogState {
  bool isLoading;
  CatalogLoadingState({required this.isLoading});
}

class CatalogLoadedState extends CatalogState {
  final List<Pais> data;
  CatalogLoadedState(this.data);
}

class CatalogLogic extends Cubit<CatalogState> {
  final CatalogService _catalogService;
  //final CacheToken _cacheToken;
  CatalogLogic(this._catalogService) : super(InitializeState());

  Future paisesLogic(BuildContext context) async {
    emit(CatalogLoadingState(isLoading: true));
    await _catalogService.fetchPaises().then((value) {
      emit(CatalogLoadingState(isLoading: false));
      if (value.isEmpty) {
        responseErrorWarning(context, 'No encontramos datos');
      } else {
        emit(CatalogLoadedState(value));
      }
    }).onError((error, stackTrace) {
      responseErrorWarning(context, 'Error en api');
      emit(CatalogLoadingState(isLoading: false));
    });
  }
}
