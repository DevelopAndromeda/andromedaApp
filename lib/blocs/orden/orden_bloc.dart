import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:appandromeda/services/customer.dart';
import 'package:appandromeda/models/response.dart';

part 'orden_event.dart';
part 'orden_state.dart';

class OrdenBloc extends Bloc<OrdenEvent, OrdenState> {
  OrdenBloc() : super(OrdenInitial()) {
    final CustomerService customerService = CustomerService();

    on<GetOrdenByEntityId>((event, emit) async {
      try {
        emit(OrdenLoading());
        final mList = await customerService.getOrderByEntityId(event.id);
        if (mList.error != null) {
          emit(OrdenError(mList.error));
        } else {
          emit(OrdenLoaded(mList));
        }
      } on NetworkError {
        emit(const OrdenError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
