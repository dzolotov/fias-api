import 'package:api/datamodel.dart';
import 'package:aqueduct/aqueduct.dart';

import 'api.dart';

class ApiChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    logger.parent.level = Level.FINE;

    Map<String, String> envVars = Platform.environment;

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    PostgreSQLPersistentStore persistentStore;
    persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        envVars['DBUSER'] ?? 'fias',
        envVars['DBPASSWORD'] ?? 'fias',
        envVars['DBHOST'] ?? '127.0.0.1',
        int.parse(envVars['DBPORT'] ?? '5432'),
        envVars['DBNAME'] ?? 'fias');

    context = ManagedContext(dataModel, persistentStore);
  }

  @override
  Controller get entryPoint {
    final router = Router();
    router
        .route("/abbr[/:id]")
        .link(() => ManagedObjectController<SocrbaseORM>(context));
    router
        .route("/search/level/:level/:text")
        .link(() => SearchLevelByText(context));
    router
        .route("/search/parent/:parent/:text")
        .link(() => SearchByParentAndText(context));
    router.route("/ping").linkFunction((req) async => Response.ok("pong"));
    router.route("/search/homes/:streetid/:text[/:building]").link(() =>
        SearchHomeForStreet(context));
    return router;
  }
}

class SearchHomeForStreet extends ResourceController {
  ManagedContext context;

  SearchHomeForStreet(this.context);

  @Operation.get("streetid","text","building")
  FutureOr<Response> searchByStreetAndBuilding(@Bind.path("streetid") String streetid, @Bind.path("text") String text, @Bind.path("building") String building) async {
    var query = Query<HouseORM>(context);
    query.where((a) => a.aoguid).equalTo(streetid);
    query.where((a) => a.housenum).beginsWith(text, caseSensitive: false);
    if (building!=null) {
      query.where((a) => a.buildnum).beginsWith(building, caseSensitive: false);
    }
    query.sortBy((a) => a.housenum, QuerySortOrder.ascending);
    query.sortBy((a) => a.buildnum, QuerySortOrder.ascending);
    query.sortBy((a) => a.startdate, QuerySortOrder.descending);
    query.fetchLimit = 10;
    var pdata = await query.fetch();
    var buildings = {};
    var mapped = [];
    for (var p in await pdata) {
      var bnum = p.buildnum;
      if (bnum==null) bnum = "0";
      if (bnum=="") bnum = "0";
      bnum = p.housenum+"-"+bnum;
      if (!buildings.containsKey(bnum)) {
        buildings[bnum] = 1;
        mapped.add(p.asMap());
      }
    }
    return Response.ok({"data": mapped});
  }

  @Operation.get("streetid","text")
  FutureOr<Response> searchByStreet(@Bind.path("streetid") String streetid, @Bind.path("text") String text) async {
    return searchByStreetAndBuilding(streetid, text, null);
  }
}

class SearchLevelByText extends ResourceController {
  ManagedContext context;

  SearchLevelByText(this.context)

  @Operation.get("level", "text")
  FutureOr<Response> searchByLevelAndText(
      @Bind.path("level") int level, @Bind.path("text") String text) async {
    var query = Query<AddrObjORM>(context);
    query.where((a) => a.aolevel).equalTo(level);
    query.where((a) => a.formalname).contains(text, caseSensitive: false);
    var mapped = [ for (var p in await query.fetch()) p.asMap() ];
    query.fetchLimit = 10;
    return Response.ok({"data": mapped});
  }
}

class SearchByParentAndText extends ResourceController {
  ManagedContext context;
  SearchByParentAndText(this.context);
  @Operation.get("parent", "text")
  FutureOr<Response> searchByLevelAndText(
      @Bind.path("parent") String parent, @Bind.path("text") String text) async {
    var query = Query<AddrObjORM>(context);
    query.where((a) => a.parentguid).equalTo(parent);
    query.where((a) => a.formalname).contains(text, caseSensitive: false);
    query.fetchLimit = 10;
    var data = [ for (var d in await query.fetch()) d.asMap() ];
    return Response.ok({"data": data});
  }
}
