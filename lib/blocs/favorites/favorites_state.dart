part of 'favorites_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final Respuesta data;
  const FavoriteLoaded(this.data);
}

class FavoriteError extends FavoriteState {
  final String? message;
  const FavoriteError(this.message);
}

class FavoriteDelete extends FavoriteState {}
