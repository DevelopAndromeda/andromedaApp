part of 'orden_bloc.dart';

sealed class OrdenEvent extends Equatable {
  const OrdenEvent();

  @override
  List<Object> get props => [];
}

class GetOrdenByEntityId extends OrdenEvent {
  final int id;
  const GetOrdenByEntityId(this.id);

  @override
  List<Object> get props => [id];
}
