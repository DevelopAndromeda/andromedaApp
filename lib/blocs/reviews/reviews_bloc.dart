import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:andromeda/services/store.dart';
import 'package:andromeda/models/response.dart';

part 'reviews_event.dart';
part 'reviews_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  ReviewsBloc() : super(ReviewsInitial()) {
    //final ApiRepository _apiRepository = ApiRepository();
    final StoreService _storeService = StoreService();

    on<GetReviewsList>((event, emit) async {
      try {
        emit(ReviewsLoading());
        final mList = await _storeService.getReviwes(event.sku);

        if (mList.error != null) {
          emit(ReviewsError(mList.error));
        }

        emit(ReviewsLoaded(mList));
      } on NetworkError {
        emit(
            const ReviewsError("Failed to fetch data. is your device online?"));
      }
    });
  }
}
