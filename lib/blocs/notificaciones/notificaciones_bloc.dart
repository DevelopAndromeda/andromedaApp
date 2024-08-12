import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:andromeda/models/response.dart';
import 'package:andromeda/services/customer.dart';

part 'notificaciones_event.dart';
part 'notificaciones_state.dart';

class NotificacionesBloc
    extends Bloc<NotificacionesEvent, NotificacionesState> {
  NotificacionesBloc() : super(NotificacionesInitial()) {
    final CustomerService customerService = CustomerService();
    on<GetNotificacionesList>((event, emit) async {
      try {
        emit(NotificacionesLoading());
        final mList = await customerService.getMyNotifications();
        if (mList.error != null) {
          emit(NotificacionesError(mList.error));
        }
        emit(NotificacionesLoaded(mList));
      } on NetworkError {
        emit(const NotificacionesError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
