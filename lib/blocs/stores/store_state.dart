part of 'store_bloc.dart';

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object?> get props => [];
}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final Respuesta data;
  const StoreLoaded(this.data);
}

class StoreError extends StoreState {
  final String? message;
  const StoreError(this.message);
}

class StoreGetById extends StoreState {}
