part of 'favorites_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class GetFavoriteList extends FavoriteEvent {}

class DeleteFavorite extends FavoriteEvent {
  final String id;
  const DeleteFavorite(this.id);

  @override
  List<Object> get props => [id];
}
