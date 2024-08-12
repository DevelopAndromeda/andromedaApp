import 'package:bloc/bloc.dart';

import 'package:andromeda/models/response.dart';
import 'package:andromeda/services/customer.dart';

import 'package:equatable/equatable.dart';

part 'reservation_event.dart';
part 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  ReservationBloc() : super(ReservationInitial()) {
    final CustomerService customerService = CustomerService();

    on<GetAllReservations>((event, emit) async {
      try {
        emit(ReservationLoading());
        final mList = await customerService.getReservations();
        if (mList.error != null) {
          emit(ReservationError(mList.error));
        }
        emit(ReservationLoaded(mList));
      } on NetworkError {
        emit(const ReservationError(
            "Failed to fetch data. is your device online?"));
      }
    });

    on<ChangeStatusReservation>((event, emit) async {
      try {
        await customerService.changeStatusOrder(event.id, event.status);

        emit(ReservationLoading());
        final mList = await customerService.getReservations();

        if (mList.error != null) {
          emit(ReservationError(mList.error));
        }

        emit(ReservationLoaded(mList));
      } on NetworkError {
        emit(const ReservationError(
            "Failed to fetch data. is your device online?"));
      }
    });
  }
}
