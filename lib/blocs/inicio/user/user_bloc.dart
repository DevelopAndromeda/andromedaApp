import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:appandromeda/services/customer.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    final CustomerService customerService = CustomerService();

    on<GetUser>((event, emit) async {
      try {
        emit(const UserLoading(isLoading: true));
        await customerService.getUserSession().then((value) {
          emit(const UserLoading(isLoading: false));
          if (value.result == 'ok') {
            emit(UserLoaded(data: value.data));
          } else {
            emit(UserError(value.data!['data']));
          }
        });
      } on NetworkError {
        emit(const UserError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
