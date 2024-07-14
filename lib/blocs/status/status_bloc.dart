import 'package:bloc/bloc.dart';

import 'package:andromeda/models/status.dart';
import 'package:andromeda/services/catalog.dart';

import 'package:equatable/equatable.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusInitial()) {
    final CatalogService catalogService = CatalogService();

    on<GetStatus>((event, emit) async {
      try {
        emit(StatusLoading());
        final mList = await catalogService.fetchStatus();

        if (mList.isEmpty) {
          emit(const StatusError("Lista de estatus vacia"));
        }

        emit(StatusLoaded(mList));
      } on NetworkError {
        emit(const StatusError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
