part of 'orden_bloc.dart';

sealed class OrdenState extends Equatable {
  const OrdenState();

  @override
  List<Object> get props => [];
}

final class OrdenInitial extends OrdenState {}

class OrdenLoading extends OrdenState {}

class OrdenLoaded extends OrdenState {
  final Respuesta data;
  const OrdenLoaded(this.data);
}

class OrdenError extends OrdenState {
  final String? message;
  const OrdenError(this.message);
}

class OrdenDelete extends OrdenState {}
