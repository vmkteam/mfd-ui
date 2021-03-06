// Code generated from zenrpc smd. DO NOT EDIT.

// To update this file:
// 1. Start mfd-generator locally on 8080 port: `mfd-generator server -a=:8080`.
// 2. Navigate in terminal to root directory of this flutter project.
// 3. `curl http://localhost:8080/doc/api_client.dart --output ./lib/services/api/api_client.dart`
// 4. `dart format --fix -l 150 ./lib/services/api/api_client.dart`
// 5. `flutter pub run build_runner build --delete-conflicting-outputs`

import 'package:json_annotation/json_annotation.dart';

part 'api_client.g.dart';

// JSONRPCClient is the main interface of executor class.
// Implementations may use different transports: http, websockets, nats, etc.
abstract class JSONRPCClient {
  Future<dynamic> call(String method, dynamic params) async {}
}

// ----- main api client class -----

class ApiClient {
  ApiClient(JSONRPCClient client)
      : project = _ServiceProject(client),
        public = _ServicePublic(client),
        xml = _ServiceXml(client),
        xmlvt = _ServiceXmlvt(client);

  final _ServiceProject project;
  final _ServicePublic public;
  final _ServiceXml xml;
  final _ServiceXmlvt xmlvt;
}

// ----- namespace classes -----

class _ServiceProject {
  _ServiceProject(this._client);

  final JSONRPCClient _client;

  // Returns currently open project
  Future<Project?> current(ProjectCurrentArgs args) {
    return Future(() async {
      final response = await _client.call('project.current', args) as Map<String, dynamic>;
      return Project.fromJson(response);
    });
  }

  // Loads project from file
  Future<Project?> open(ProjectOpenArgs args) {
    return Future(() async {
      final response = await _client.call('project.open', args) as Map<String, dynamic>;
      return Project.fromJson(response);
    });
  }

  // Saves project from memory to disk
  Future<void> save(ProjectSaveArgs args) {
    return Future(() async {
      await _client.call('project.save', args);
    });
  }

  // Gets all tables from database
  Future<List<String?>?> tables(ProjectTablesArgs args) {
    return Future(() async {
      final response = await _client.call('project.tables', args) as List?;
      final responseList = response?.map((e) {
        if (e == null) {
          return null;
        }
        return e as String;
      });
      return responseList?.toList();
    });
  }

  // Updates project in memory
  Future<void> update(ProjectUpdateArgs args) {
    return Future(() async {
      await _client.call('project.update', args);
    });
  }
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ProjectCurrentArgs {
  ProjectCurrentArgs();

  factory ProjectCurrentArgs.fromJson(Map<String, dynamic> json) => _$ProjectCurrentArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectCurrentArgsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ProjectOpenArgs {
  ProjectOpenArgs({this.connection, this.filePath});

  factory ProjectOpenArgs.fromJson(Map<String, dynamic> json) => _$ProjectOpenArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectOpenArgsToJson(this);

  final String? connection;
  final String? filePath;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ProjectSaveArgs {
  ProjectSaveArgs();

  factory ProjectSaveArgs.fromJson(Map<String, dynamic> json) => _$ProjectSaveArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectSaveArgsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ProjectTablesArgs {
  ProjectTablesArgs();

  factory ProjectTablesArgs.fromJson(Map<String, dynamic> json) => _$ProjectTablesArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectTablesArgsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ProjectUpdateArgs {
  ProjectUpdateArgs({this.project});

  factory ProjectUpdateArgs.fromJson(Map<String, dynamic> json) => _$ProjectUpdateArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectUpdateArgsToJson(this);

  final Project? project;
}

class _ServicePublic {
  _ServicePublic(this._client);

  final JSONRPCClient _client;

  // Gets postgres types
  Future<List<String?>?> dBTypes(PublicDBTypesArgs args) {
    return Future(() async {
      final response = await _client.call('public.dBTypes', args) as List?;
      final responseList = response?.map((e) {
        if (e == null) {
          return null;
        }
        return e as String;
      });
      return responseList?.toList();
    });
  }

  // Gets all supported go-pg versions
  Future<List<int?>?> goPGVersions(PublicGoPGVersionsArgs args) {
    return Future(() async {
      final response = await _client.call('public.goPGVersions', args) as List?;
      final responseList = response?.map((e) {
        if (e == null) {
          return null;
        }
        return e as int;
      });
      return responseList?.toList();
    });
  }

  Future<List<String?>?> hTMLTypes(PublicHTMLTypesArgs args) {
    return Future(() async {
      final response = await _client.call('public.hTMLTypes', args) as List?;
      final responseList = response?.map((e) {
        if (e == null) {
          return null;
        }
        return e as String;
      });
      return responseList?.toList();
    });
  }

  // Gets all available entity modes
  Future<List<String?>?> modes(PublicModesArgs args) {
    return Future(() async {
      final response = await _client.call('public.modes', args) as List?;
      final responseList = response?.map((e) {
        if (e == null) {
          return null;
        }
        return e as String;
      });
      return responseList?.toList();
    });
  }

  Future<String?> ping(PublicPingArgs args) {
    return Future(() async {
      final response = await _client.call('public.ping', args) as String?;
      return response;
    });
  }

  // Gets all available search types
  Future<List<String?>?> searchTypes(PublicSearchTypesArgs args) {
    return Future(() async {
      final response = await _client.call('public.searchTypes', args) as List?;
      final responseList = response?.map((e) {
        if (e == null) {
          return null;
        }
        return e as String;
      });
      return responseList?.toList();
    });
  }

  // Gets std types
  Future<List<String?>?> types(PublicTypesArgs args) {
    return Future(() async {
      final response = await _client.call('public.types', args) as List?;
      final responseList = response?.map((e) {
        if (e == null) {
          return null;
        }
        return e as String;
      });
      return responseList?.toList();
    });
  }
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PublicDBTypesArgs {
  PublicDBTypesArgs();

  factory PublicDBTypesArgs.fromJson(Map<String, dynamic> json) => _$PublicDBTypesArgsFromJson(json);

  Map<String, dynamic> toJson() => _$PublicDBTypesArgsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PublicGoPGVersionsArgs {
  PublicGoPGVersionsArgs();

  factory PublicGoPGVersionsArgs.fromJson(Map<String, dynamic> json) => _$PublicGoPGVersionsArgsFromJson(json);

  Map<String, dynamic> toJson() => _$PublicGoPGVersionsArgsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PublicHTMLTypesArgs {
  PublicHTMLTypesArgs();

  factory PublicHTMLTypesArgs.fromJson(Map<String, dynamic> json) => _$PublicHTMLTypesArgsFromJson(json);

  Map<String, dynamic> toJson() => _$PublicHTMLTypesArgsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PublicModesArgs {
  PublicModesArgs();

  factory PublicModesArgs.fromJson(Map<String, dynamic> json) => _$PublicModesArgsFromJson(json);

  Map<String, dynamic> toJson() => _$PublicModesArgsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PublicPingArgs {
  PublicPingArgs();

  factory PublicPingArgs.fromJson(Map<String, dynamic> json) => _$PublicPingArgsFromJson(json);

  Map<String, dynamic> toJson() => _$PublicPingArgsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PublicSearchTypesArgs {
  PublicSearchTypesArgs();

  factory PublicSearchTypesArgs.fromJson(Map<String, dynamic> json) => _$PublicSearchTypesArgsFromJson(json);

  Map<String, dynamic> toJson() => _$PublicSearchTypesArgsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PublicTypesArgs {
  PublicTypesArgs();

  factory PublicTypesArgs.fromJson(Map<String, dynamic> json) => _$PublicTypesArgsFromJson(json);

  Map<String, dynamic> toJson() => _$PublicTypesArgsToJson(this);
}

class _ServiceXml {
  _ServiceXml(this._client);

  final JSONRPCClient _client;

  // Gets entity for selected table
  Future<Entity?> generateEntity(XmlGenerateEntityArgs args) {
    return Future(() async {
      final response = await _client.call('xml.generateEntity', args) as Map<String, dynamic>;
      return Entity.fromJson(response);
    });
  }

  // Generates model go code, that represents this entity.
  Future<String?> generateModelCode(XmlGenerateModelCodeArgs args) {
    return Future(() async {
      final response = await _client.call('xml.generateModelCode', args) as String?;
      return response;
    });
  }

  // Generates search go code, that represents this entity.
  Future<String?> generateSearchModelCode(XmlGenerateSearchModelCodeArgs args) {
    return Future(() async {
      final response = await _client.call('xml.generateSearchModelCode', args) as String?;
      return response;
    });
  }

  // Gets selected entity from project
  Future<Entity?> loadEntity(XmlLoadEntityArgs args) {
    return Future(() async {
      final response = await _client.call('xml.loadEntity', args) as Map<String, dynamic>;
      return Entity.fromJson(response);
    });
  }

  // Saves selected entity in project
  Future<void> updateEntity(XmlUpdateEntityArgs args) {
    return Future(() async {
      await _client.call('xml.updateEntity', args);
    });
  }
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlGenerateEntityArgs {
  XmlGenerateEntityArgs({this.namespace, this.table});

  factory XmlGenerateEntityArgs.fromJson(Map<String, dynamic> json) => _$XmlGenerateEntityArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlGenerateEntityArgsToJson(this);

  final String? namespace;
  final String? table;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlGenerateModelCodeArgs {
  XmlGenerateModelCodeArgs({this.entity});

  factory XmlGenerateModelCodeArgs.fromJson(Map<String, dynamic> json) => _$XmlGenerateModelCodeArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlGenerateModelCodeArgsToJson(this);

  final Entity? entity;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlGenerateSearchModelCodeArgs {
  XmlGenerateSearchModelCodeArgs({this.entity});

  factory XmlGenerateSearchModelCodeArgs.fromJson(Map<String, dynamic> json) => _$XmlGenerateSearchModelCodeArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlGenerateSearchModelCodeArgsToJson(this);

  final Entity? entity;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlLoadEntityArgs {
  XmlLoadEntityArgs({this.entity, this.namespace});

  factory XmlLoadEntityArgs.fromJson(Map<String, dynamic> json) => _$XmlLoadEntityArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlLoadEntityArgsToJson(this);

  final String? entity;
  final String? namespace;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlUpdateEntityArgs {
  XmlUpdateEntityArgs({this.entity});

  factory XmlUpdateEntityArgs.fromJson(Map<String, dynamic> json) => _$XmlUpdateEntityArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlUpdateEntityArgsToJson(this);

  final Entity? entity;
}

class _ServiceXmlvt {
  _ServiceXmlvt(this._client);

  final JSONRPCClient _client;

  // Gets vt entity for selected base entity
  Future<VTEntity?> generateEntity(XmlvtGenerateEntityArgs args) {
    return Future(() async {
      final response = await _client.call('xmlvt.generateEntity', args) as Map<String, dynamic>;
      return VTEntity.fromJson(response);
    });
  }

  // Gets vt entity for selected entity from project
  Future<VTEntity?> loadEntity(XmlvtLoadEntityArgs args) {
    return Future(() async {
      final response = await _client.call('xmlvt.loadEntity', args) as Map<String, dynamic>;
      return VTEntity.fromJson(response);
    });
  }

  // Saves vt entity in project
  Future<void> updateEntity(XmlvtUpdateEntityArgs args) {
    return Future(() async {
      await _client.call('xmlvt.updateEntity', args);
    });
  }
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlvtGenerateEntityArgs {
  XmlvtGenerateEntityArgs({this.entity, this.namespace});

  factory XmlvtGenerateEntityArgs.fromJson(Map<String, dynamic> json) => _$XmlvtGenerateEntityArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlvtGenerateEntityArgsToJson(this);

  final String? entity;
  final String? namespace;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlvtLoadEntityArgs {
  XmlvtLoadEntityArgs({this.entity, this.namespace});

  factory XmlvtLoadEntityArgs.fromJson(Map<String, dynamic> json) => _$XmlvtLoadEntityArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlvtLoadEntityArgsToJson(this);

  final String? entity;
  final String? namespace;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlvtUpdateEntityArgs {
  XmlvtUpdateEntityArgs({this.entity, this.namespace});

  factory XmlvtUpdateEntityArgs.fromJson(Map<String, dynamic> json) => _$XmlvtUpdateEntityArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlvtUpdateEntityArgsToJson(this);

  final VTEntity? entity;
  final String? namespace;
}

// ----- models -----

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Entity {
  Entity({this.attributes, this.name, this.namespace, this.searches, this.table});

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

  Map<String, dynamic> toJson() => _$EntityToJson(this);

  final List<MfdAttributes?>? attributes;
  final String? name;
  final String? namespace;
  final List<MfdSearches?>? searches;
  final String? table;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class MfdAttributes {
  MfdAttributes(
      {this.addable,
      this.dbName,
      this.dbType,
      this.defaultVal,
      this.disablePointer,
      this.fk,
      this.goType,
      this.isArray,
      this.max,
      this.min,
      this.name,
      this.nullable,
      this.pk,
      this.updatable});

  factory MfdAttributes.fromJson(Map<String, dynamic> json) => _$MfdAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$MfdAttributesToJson(this);

  final bool? addable;
  final String? dbName;
  final String? dbType;
  final String? defaultVal;
  final bool? disablePointer;
  final String? fk;
  final String? goType;
  final bool? isArray;
  final int? max;
  final int? min;
  final String? name;
  final String? nullable;
  final bool? pk;
  final bool? updatable;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class MfdCustomTypes {
  MfdCustomTypes({this.dbType, this.goImport, this.goType});

  factory MfdCustomTypes.fromJson(Map<String, dynamic> json) => _$MfdCustomTypesFromJson(json);

  Map<String, dynamic> toJson() => _$MfdCustomTypesToJson(this);

  final String? dbType;
  final String? goImport;
  final String? goType;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class MfdNSMapping {
  MfdNSMapping({this.entity, this.namespace});

  factory MfdNSMapping.fromJson(Map<String, dynamic> json) => _$MfdNSMappingFromJson(json);

  Map<String, dynamic> toJson() => _$MfdNSMappingToJson(this);

  final String? entity;
  final String? namespace;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class MfdSearches {
  MfdSearches({this.attrName, this.goType, this.name, this.searchType});

  factory MfdSearches.fromJson(Map<String, dynamic> json) => _$MfdSearchesFromJson(json);

  Map<String, dynamic> toJson() => _$MfdSearchesToJson(this);

  final String? attrName;
  final String? goType;
  final String? name;
  final String? searchType;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class MfdTmplAttributes {
  MfdTmplAttributes({this.fkOpts, this.form, this.list, this.name, this.search, this.vtAttrName});

  factory MfdTmplAttributes.fromJson(Map<String, dynamic> json) => _$MfdTmplAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$MfdTmplAttributesToJson(this);

  final String? fkOpts;
  final String? form;
  final bool? list;
  final String? name;
  final String? search;
  final String? vtAttrName;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class MfdVTAttributes {
  MfdVTAttributes({this.attrName, this.max, this.min, this.name, this.required, this.search, this.searchName, this.summary, this.validate});

  factory MfdVTAttributes.fromJson(Map<String, dynamic> json) => _$MfdVTAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$MfdVTAttributesToJson(this);

  final String? attrName;
  final int? max;
  final int? min;
  final String? name;
  final bool? required;
  final bool? search;
  final String? searchName;
  final bool? summary;
  final String? validate;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Project {
  Project({this.customTypes, this.goPGVer, this.languages, this.name, this.namespaces});

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  final List<MfdCustomTypes?>? customTypes;
  final int? goPGVer;
  final List<String?>? languages;
  final String? name;
  final List<MfdNSMapping?>? namespaces;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class VTEntity {
  VTEntity({this.attributes, this.mode, this.name, this.template, this.terminalPath});

  factory VTEntity.fromJson(Map<String, dynamic> json) => _$VTEntityFromJson(json);

  Map<String, dynamic> toJson() => _$VTEntityToJson(this);

  final List<MfdVTAttributes?>? attributes;
  final String? mode;
  final String? name;
  final List<MfdTmplAttributes?>? template;
  final String? terminalPath;
}
