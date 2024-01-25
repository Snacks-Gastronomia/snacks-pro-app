part of "home_cubit.dart";

class HomeState {
  final List<Item> items;
  final int numberOfPostsPerRequest;
  final bool listIsLastPage;
  final DocumentSnapshot? lastDocument;
  final List<Item> popular;
  final AppStatus status;
  final bool search;
  final String? category;
  final String? query;
  final String? error;
  final Stream<QuerySnapshot<Map<String, dynamic>>> menu;
  HomeState({
    required this.items,
    required this.numberOfPostsPerRequest,
    required this.listIsLastPage,
    this.lastDocument,
    required this.popular,
    required this.status,
    required this.search,
    required this.category,
    required this.query,
    required this.error,
    required this.menu,
  });

  factory HomeState.initial() => HomeState(
      search: false,
      category: null,
      query: "",
      items: [],
      menu: const Stream.empty(),
      popular: [],
      status: AppStatus.initial,
      listIsLastPage: false,
      numberOfPostsPerRequest: 15,
      error: null);

  @override
  String toString() => 'HomeState(items: $items, popular: $popular)';

  @override
  int get hashCode {
    return items.hashCode ^
        numberOfPostsPerRequest.hashCode ^
        listIsLastPage.hashCode ^
        lastDocument.hashCode ^
        popular.hashCode ^
        status.hashCode ^
        search.hashCode ^
        query.hashCode ^
        category.hashCode ^
        error.hashCode;
  }

  HomeState copyWith(
      {List<Item>? items,
      int? numberOfPostsPerRequest,
      bool? listIsLastPage,
      DocumentSnapshot? lastDocument,
      List<Item>? popular,
      AppStatus? status,
      Stream<QuerySnapshot<Map<String, dynamic>>>? menu,
      bool? search,
      String? category,
      String? query,
      String? error}) {
    return HomeState(
      items: items ?? this.items,
      numberOfPostsPerRequest:
          numberOfPostsPerRequest ?? this.numberOfPostsPerRequest,
      listIsLastPage: listIsLastPage ?? this.listIsLastPage,
      lastDocument: lastDocument ?? this.lastDocument,
      popular: popular ?? this.popular,
      query: query ?? this.query,
      status: status ?? this.status,
      search: search ?? this.search,
      category: category ?? this.category,
      menu: menu ?? this.menu,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeState &&
        listEquals(other.items, items) &&
        other.numberOfPostsPerRequest == numberOfPostsPerRequest &&
        other.listIsLastPage == listIsLastPage &&
        other.lastDocument == lastDocument &&
        listEquals(other.popular, popular) &&
        other.status == status &&
        other.search == search &&
        other.query == query &&
        other.category == category &&
        other.menu == menu &&
        other.error == error;
  }
}
