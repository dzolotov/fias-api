import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/aqueduct.dart' as prefix0;

class SocrbaseORM extends ManagedObject<socrbase> implements socrbase {}

class socrbase {
  @Column(nullable: true)
  String socrname;

  @Column(nullable: true)
  String scname;

  @Column(primaryKey: true)
  String kod_t_st;

  @Column()
  int level;
}

class AddrObjORM extends ManagedObject<addrobj> implements addrobj {}

class addrobj {
  @Column(nullable: true)
  String areacode;

  @Column(nullable: true)
  String autocode;

  @Column(nullable: true)
  String citycode;

  @Column(nullable: true)
  String code;

  @Column(primaryKey: true)
  String aoguid;

  @Column(nullable: true)
  String aoid;

  @Column(nullable: true)
  DateTime enddate;

  @Column(nullable: true)
  String formalname;

  @Column(nullable: true)
  String ifnsfl;

  @Column(nullable: true)
  String ifnsul;

  @Column(nullable: true)
  String offname;

  @Column(nullable: true)
  String okato;

  @Column(nullable: true)
  String oktmo;

  @Column(nullable: true)
  String placecode;

  @Column(nullable: true)
  String plaincode;

  @Column(nullable: true)
  String postalcode;

  @Column(nullable: true)
  String regioncode;

  @Column(nullable: true)
  String streetcode;

  @Column(nullable: true)
  String shortname;

  @Column(nullable: true)
  DateTime startdate;

  @Column(nullable: true)
  String terrifnsfl;

  @Column(nullable: true)
  String terrifnsul;

  @Column(nullable: true)
  DateTime updatedate;

  @Column(nullable: true)
  String ctarcode;

  @Column(nullable: true)
  String extrcode;

  @Column(nullable: true)
  String sextcode;

  @Column(nullable: true)
  String plancode;

  @Column(nullable: true)
  String cadnum;

  @Column(nullable: true)
  int actstatus;

  @Column(nullable: true)
  int aolevel;

  @Column(nullable: true)
  int centstatus;

  @Column(nullable: true)
  int currstatus;

  @Column(nullable: true)
  int livestatus;

  @Column(nullable: true)
  String nextid;

  @Column(nullable: true)
  String normdoc;

  @Column(nullable: true)
  int operstatus;

  @Column(nullable: true)
  String parentguid;
}

class HouseORM extends ManagedObject<house> implements house {}

class house {
  @Column(primaryKey: false)
  String aoguid;

  @Column(primaryKey: false)
  String buildnum;

  @Column(primaryKey: false)
  DateTime enddate;

  @Column(primaryKey: false)
  String eststatus;

  @Column(primaryKey: true)
  String houseguid;

  @Column(primaryKey: false)
  String houseid;

  @Column(primaryKey: false)
  String housenum;

  @Column(primaryKey: false)
  String okato;

  @Column(primaryKey: false)
  String oktmo;

  @Column(primaryKey: false)
  String postalcode;

  @Column(primaryKey: false)
  DateTime startdate;
}

class FlatTypeORM extends ManagedObject<flattype> implements flattype {}

class flattype {
  @Column(primaryKey: true)
  String fltypeid;

  @Column(primaryKey: false)
  String name;

  @Column(primaryKey: false)
  String shortname;
}

class RoomORM extends ManagedObject<room> implements room {}

class room {
  @Column(primaryKey: false)
  String roomid;

  @Column(primaryKey: true)
  String roomguid;

  @Column(primaryKey: false)
  String houseguid;

  @Column(primaryKey: false)
  String regioncode;

  @Column(primaryKey: false)
  String flatnumber;

  @Column(primaryKey: false)
  String flattype;

  @Column(primaryKey: false)
  String roomnumber;

  @Column(primaryKey: false)
  String roomtype;

  @Column(primaryKey: false)
  String postalcode;

  @Column(primaryKey: false)
  DateTime startdate;

  @Column(primaryKey: false)
  DateTime enddate;

  @Column(primaryKey: false)
  String livestatus;
}
