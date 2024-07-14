part of 'notificaciones_bloc.dart';

abstract class NotificacionesEvent extends Equatable {
  const NotificacionesEvent();

  @override
  List<Object> get props => [];
}

class GetNotificacionesList extends NotificacionesEvent {}
