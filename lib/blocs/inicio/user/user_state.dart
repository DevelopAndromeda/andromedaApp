part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {
  final bool isLoading;
  const UserLoading({required this.isLoading});
}

class UserLoaded extends UserState {
  final dynamic data;
  const UserLoaded({required this.data});
}

class UserError extends UserState {
  final String? message;
  const UserError(this.message);
}
