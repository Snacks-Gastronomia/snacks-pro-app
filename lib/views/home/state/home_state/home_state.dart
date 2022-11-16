part of "home_cubit.dart";

class HomeState {
  final List<Item> items;
  final int numberOfPostsPerRequest;
  final bool listIsLastPage;
  final int listPageNumber;
  final List<Item> popular;
  final AppStatus status;
  final bool search;
  final String? category;
  final String? error;
  final Map<String, dynamic> storage;
  HomeState({
    required this.items,
    required this.numberOfPostsPerRequest,
    required this.listIsLastPage,
    required this.listPageNumber,
    required this.popular,
    required this.status,
    required this.search,
    required this.category,
    required this.error,
    required this.storage,
  });

  factory HomeState.initial() => HomeState(
      search: false,
      category: null,
      storage: {},
      items: [],
      popular: [],
      status: AppStatus.initial,
      listIsLastPage: false,
      listPageNumber: 1,
      numberOfPostsPerRequest: 15,
      error: null);

  @override
  String toString() => 'HomeState(items: $items, popular: $popular)';

  @override
  int get hashCode {
    return items.hashCode ^
        numberOfPostsPerRequest.hashCode ^
        listIsLastPage.hashCode ^
        listPageNumber.hashCode ^
        popular.hashCode ^
        status.hashCode ^
        search.hashCode ^
        category.hashCode ^
        error.hashCode ^
        storage.hashCode;
  }

  HomeState copyWith({
    List<Item>? items,
    int? numberOfPostsPerRequest,
    bool? listIsLastPage,
    int? listPageNumber,
    List<Item>? popular,
    AppStatus? status,
    bool? search,
    String? category,
    String? error,
    Map<String, dynamic>? storage,
  }) {
    return HomeState(
      items: items ?? this.items,
      numberOfPostsPerRequest:
          numberOfPostsPerRequest ?? this.numberOfPostsPerRequest,
      listIsLastPage: listIsLastPage ?? this.listIsLastPage,
      listPageNumber: listPageNumber ?? this.listPageNumber,
      popular: popular ?? this.popular,
      status: status ?? this.status,
      search: search ?? this.search,
      category: category ?? this.category,
      error: error ?? this.error,
      storage: storage ?? this.storage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeState &&
        listEquals(other.items, items) &&
        other.numberOfPostsPerRequest == numberOfPostsPerRequest &&
        other.listIsLastPage == listIsLastPage &&
        other.listPageNumber == listPageNumber &&
        listEquals(other.popular, popular) &&
        other.status == status &&
        other.search == search &&
        other.category == category &&
        other.error == error &&
        mapEquals(other.storage, storage);
  }
}
