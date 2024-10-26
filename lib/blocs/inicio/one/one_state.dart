part of 'one_bloc.dart';

abstract class OneState extends Equatable {
  const OneState();

  @override
  List<Object?> get props => [];
}

class OneInitial extends OneState {}

class OneLoading extends OneState {}

class OneLoaded extends OneState {
  final Respuesta data;
  const OneLoaded(this.data);
}

class OneError extends OneState {
  final String? message;
  const OneError(this.message);
}

class OneErrorSession extends OneState {
  const OneErrorSession();
}

class OneLoadedEmpty extends OneState {
  const OneLoadedEmpty();
}

class FavoriteDelete extends OneState {}
