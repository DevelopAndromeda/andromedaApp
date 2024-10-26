import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:appandromeda/services/customer.dart';

import 'package:appandromeda/models/response.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    //final ApiRepository _apiRepository = ApiRepository();
    final CustomerService customerService = CustomerService();

    on<GetHistoryList>((event, emit) async {
      try {
        emit(HistoryLoading());
        final mList = await customerService.getMyOrders();
        if (mList.error != null) {
          emit(HistoryError(mList.error));
        } else {
          emit(HistoryLoaded(mList));
        }
      } on NetworkError {
        emit(
            const HistoryError("Failed to fetch data. is your device online?"));
      }
    });

    on<ChangeStatusHistory>((event, emit) async {
      try {
        await customerService
            .changeStatusOrder(event.id, event.status)
            .then((value) async {
          //emit(HistoryLoading());
          final mList = await customerService.getMyOrders();

          if (mList.error != null) {
            emit(HistoryError(mList.error));
          } else {
            emit(HistoryLoaded(mList));
          }
        });
      } on NetworkError {
        emit(
            const HistoryError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
