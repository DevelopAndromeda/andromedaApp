part of 'all_bloc.dart';

abstract class AllState extends Equatable {
  const AllState();

  @override
  List<Object?> get props => [];
}

class AllInitial extends AllState {}

class AllLoading extends AllState {}

class AllLoaded extends AllState {
  final Respuesta data;
  const AllLoaded(this.data);
}

class AllError extends AllState {
  final String? message;
  const AllError(this.message);
}
