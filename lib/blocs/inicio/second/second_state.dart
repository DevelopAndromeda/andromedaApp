part of 'second_bloc.dart';

abstract class SecondState extends Equatable {
  const SecondState();

  @override
  List<Object?> get props => [];
}

class SecondInitial extends SecondState {}

class SecondLoading extends SecondState {}

class SecondLoaded extends SecondState {
  final Respuesta data;
  const SecondLoaded(this.data);
}

class SecondError extends SecondState {
  final String? message;
  const SecondError(this.message);
}
