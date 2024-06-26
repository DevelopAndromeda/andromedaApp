part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class GetHistoryList extends HistoryEvent {}

class ChangeStatusHistory extends HistoryEvent {
  final String id;
  final String status;
  const ChangeStatusHistory(this.id, this.status);

  @override
  List<Object> get props => [id, status];
}
