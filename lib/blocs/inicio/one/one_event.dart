part of 'one_bloc.dart';

abstract class OneEvent extends Equatable {
  const OneEvent();

  @override
  List<Object> get props => [];
}

class GetOneList extends OneEvent {}
