import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:appandromeda/models/response.dart';
import 'package:appandromeda/services/customer.dart';

part 'notificaciones_event.dart';
part 'notificaciones_state.dart';

class NotificacionesBloc
    extends Bloc<NotificacionesEvent, NotificacionesState> {
  NotificacionesBloc() : super(NotificacionesInitial()) {
    final CustomerService customerService = CustomerService();
    on<GetNotificacionesList>((event, emit) async {
      emit(NotificacionesLoading());

      try {
        final mList = await customerService.getMyNotifications();

        if (mList.result == 'ok') {
          emit(NotificacionesLoaded(mList));
        }

        if (mList.result == 'excep') {
          emit(const NotificacionesErrorSession());
        }

        if (mList.result == 'fail') {
          emit(const NotificacionesLoadedEmpty());
        }
        /*if (mList.error != null) {
          emit(NotificacionesError(mList.error));
        } else {
          emit(NotificacionesLoaded(mList));
        }*/
      } on NetworkError {
        emit(const NotificacionesError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
