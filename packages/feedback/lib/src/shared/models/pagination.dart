import 'package:equatable/equatable.dart';

enum OrderBy { asc, desc }

class Pagination extends Equatable {
  const Pagination({this.page = 1, this.limit = 30});

  final int page;
  final int limit;

  @override
  List<Object?> get props => [page, limit];

  Map<String, String> toJson() {
    return {'page': page.toString(), 'itemsPerPage': limit.toString()};
  }
}

class Order extends Equatable {
  const Order(this.property, {this.orderBy = OrderBy.desc});

  final String property;
  final OrderBy orderBy;

  @override
  List<Object?> get props => [property, orderBy];

  Map<String, String> toJson() {
    return {'order[$property]': orderBy.name};
  }
}
