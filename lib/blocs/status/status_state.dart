part of 'status_bloc.dart';

abstract class StatusState extends Equatable {
  const StatusState();

  @override
  List<Object?> get props => [];
}

class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {}

class StatusLoaded extends StatusState {
  final List<Status> data;
  const StatusLoaded(this.data);
}

class StatusError extends StatusState {
  final String? message;
  const StatusError(this.message);
}
