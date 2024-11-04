part of 'second_bloc.dart';

abstract class SecondEvent extends Equatable {
  const SecondEvent();

  @override
  List<Object> get props => [];
}

class GetSecondList extends SecondEvent {}
