part of 'reviews_bloc.dart';

abstract class ReviewsEvent extends Equatable {
  const ReviewsEvent();

  @override
  List<Object> get props => [];
}

class GetReviewsList extends ReviewsEvent {
  final String sku;
  const GetReviewsList(this.sku);

  @override
  List<Object> get props => [sku];
}
