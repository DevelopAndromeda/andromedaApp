part of 'notificaciones_bloc.dart';

abstract class NotificacionesState extends Equatable {
  const NotificacionesState();

  @override
  List<Object> get props => [];
}

final class NotificacionesInitial extends NotificacionesState {}

class NotificacionesLoading extends NotificacionesState {}

class NotificacionesLoaded extends NotificacionesState {
  final Respuesta data;
  const NotificacionesLoaded(this.data);
}

class NotificacionesError extends NotificacionesState {
  final String? message;
  const NotificacionesError(this.message);
}

class NotificacionesDelete extends NotificacionesState {}
