part of 'all_bloc.dart';

abstract class AllEvent extends Equatable {
  const AllEvent();

  @override
  List<Object> get props => [];
}

class GetAllList extends AllEvent {}
