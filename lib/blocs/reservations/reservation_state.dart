part of 'reservation_bloc.dart';

abstract class ReservationState extends Equatable {
  const ReservationState();

  @override
  List<Object?> get props => [];
}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationLoaded extends ReservationState {
  final Respuesta data;
  const ReservationLoaded(this.data);
}

class ReservationError extends ReservationState {
  final String? message;
  const ReservationError(this.message);
}
