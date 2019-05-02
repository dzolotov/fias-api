import 'dart:async';
import 'dart:mirrors' as mirrors;

import 'package:aqueduct/aqueduct.dart';

class ManagedSearchableObjectController<T extends ManagedObject>
    extends ManagedObjectController<T> {
  final List filters;

  ManagedSearchableObjectController(
      final ManagedContext context, final List this.filters)
      : super(context);

  @override
  @DynamicOperation.get()
  Future<Response> getObjects(
      {@Bind.query("count") int count = 0,
      @Bind.query("offset") int offset = 0,
      @Bind.query("pageBy") String pageBy,
      @Bind.query("pageAfter") String pageAfter,
      @Bind.query("pagePrior") String pagePrior,
      @Bind.query("sortBy") List<String> sortBy}) {
    return super.getObjects(
        count: count,
        offset: offset,
        pageBy: pageBy,
        pageAfter: pageAfter,
        pagePrior: pagePrior,
        sortBy: sortBy);
  }

  @override
  FutureOr<Query<T>> willFindObjectsWithQuery(Query<T> query) async {
    for (var key in filters) {
      if (key[0] == '#') {
        key = key.substring(1);
        print(key);
        var num = int.parse(request.path.variables[key].toString());
        print(num);
        query.where((T t) {
          var r = mirrors.reflect(t);
          var x = r.getField(Symbol(key)).reflectee;
          return x;
        }).equalTo(num);
      } else {
        query.where((T t) {
          var r = mirrors.reflect(t);
          var x = r.getField(Symbol(key)).reflectee;
          return x;
        }).equalTo(request.path.variables[key].toString());
      }
    }
    query = super.willFindObjectsWithQuery(query);
    return query;
  }

  @override
  FutureOr<Query<T>> willDeleteObjectWithQuery(Query<T> query) async {
    for (var key in filters) {
      query.where((T t) {
        var r = mirrors.reflect(t);
        var x = r.getField(Symbol(key)).reflectee;
        return x;
      }).equalTo(request.path.variables[key].toString());
    }
    query = super.willDeleteObjectWithQuery(query);
    return query;
  }

  @override
  FutureOr<Query<T>> willInsertObjectWithQuery(Query<T> query) async {
    for (var key in filters) {
      var r = query.values;
      mirrors
          .reflect(r)
          .setField(Symbol(key), request.path.variables[key].toString());
    }
    query = super.willInsertObjectWithQuery(query);
  }
}
