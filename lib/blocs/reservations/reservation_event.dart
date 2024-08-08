part of 'reservation_bloc.dart';

abstract class ReservationEvent extends Equatable {
  const ReservationEvent();

  @override
  List<Object> get props => [];
}

class GetAllReservations extends ReservationEvent {}

class ChangeStatusReservation extends ReservationEvent {
  final String id;
  final String status;
  const ChangeStatusReservation(this.id, this.status);

  @override
  List<Object> get props => [id, status];
}
