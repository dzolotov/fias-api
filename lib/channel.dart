import 'package:api/datamodel.dart';
import 'package:aqueduct/aqueduct.dart';

import 'api.dart';
import 'controllers/ManagedSearchableObjectController.dart';

class ApiChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    logger.parent.level = Level.INFO;

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
    var p =
        ManagedSearchableObjectController<AddrObjORM>(context, ["areacode"]);
    router.route("/address/ac/:areacode").link(() => p);
    router.route("/address/cc/:citycode").link(() =>
        ManagedSearchableObjectController<AddrObjORM>(context, ["citycode"]));
    router.route("/address/level/:aolevel").link(() =>
        ManagedSearchableObjectController<AddrObjORM>(context, ["#aolevel"]));
    router.route("/address/uuid/:aoguid").link(() =>
        ManagedSearchableObjectController<AddrObjORM>(context, ["aoguid"]));
    router
        .route("/search/level/:level/:text")
        .link(() => SearchLevelByText(context));
    router.route("/ping").linkFunction((req) async => Response.ok("pong"));
    return router;
  }
}

class SearchLevelByText extends ResourceController {
  ManagedContext context;

  SearchLevelByText(this.context);

  @Operation.get("level", "text")
  FutureOr<Response> searchByLevelAndText(
      @Bind.path("level") int level, @Bind.path("text") String text) async {
    var query = Query<AddrObjORM>(context);
    query.where((a) => a.aolevel).equalTo(level);
    query.where((a) => a.formalname).contains(text, caseSensitive: false);
    query.fetchLimit = 10;
    return Response.ok({"data": await query.fetch()});
  }
}
