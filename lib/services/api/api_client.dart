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
  ApiClient(JSONRPCClient client) : api = _ServiceApi(client);

  final _ServiceApi api;
}

// ----- namespace classes -----

class _ServiceApi {
  _ServiceApi(this._client);

  final JSONRPCClient _client;

  Future<void> openProject(ApiOpenProjectArgs args) {
    return Future(() async {
      await _client.call('api.openProject', args);
    });
  }

  Future<String?> ping(ApiPingArgs args) {
    return Future(() async {
      final response = await _client.call('api.ping', args) as String?;
      return response;
    });
  }

  Future<Project?> project(ApiProjectArgs args) {
    return Future(() async {
      final response = await _client.call('api.project', args) as Map<String, dynamic>;
      return Project.fromJson(response);
    });
  }

  Future<void> projectx(ApiProjectxArgs args) {
    return Future(() async {
      await _client.call('api.projectx', args);
    });
  }

  Future<void> saveProject(ApiSaveProjectArgs args) {
    return Future(() async {
      await _client.call('api.saveProject', args);
    });
  }

  Future<void> updateEntityAttributes(ApiUpdateEntityAttributesArgs args) {
    return Future(() async {
      await _client.call('api.updateEntityAttributes', args);
    });
  }

  Future<void> updateEntitySearches(ApiUpdateEntitySearchesArgs args) {
    return Future(() async {
      await _client.call('api.updateEntitySearches', args);
    });
  }
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ApiOpenProjectArgs {
  ApiOpenProjectArgs({this.filepath});

  factory ApiOpenProjectArgs.fromJson(Map<String, dynamic> json) => _$ApiOpenProjectArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ApiOpenProjectArgsToJson(this);

  final String? filepath;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ApiPingArgs {
  ApiPingArgs();

  factory ApiPingArgs.fromJson(Map<String, dynamic> json) => _$ApiPingArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ApiPingArgsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ApiProjectArgs {
  ApiProjectArgs({this.filepath});

  factory ApiProjectArgs.fromJson(Map<String, dynamic> json) => _$ApiProjectArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ApiProjectArgsToJson(this);

  final String? filepath;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ApiProjectxArgs {
  ApiProjectxArgs();

  factory ApiProjectxArgs.fromJson(Map<String, dynamic> json) => _$ApiProjectxArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ApiProjectxArgsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ApiSaveProjectArgs {
  ApiSaveProjectArgs();

  factory ApiSaveProjectArgs.fromJson(Map<String, dynamic> json) => _$ApiSaveProjectArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ApiSaveProjectArgsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ApiUpdateEntityAttributesArgs {
  ApiUpdateEntityAttributesArgs({this.entity, this.namespace, this.newAttributes});

  factory ApiUpdateEntityAttributesArgs.fromJson(Map<String, dynamic> json) => _$ApiUpdateEntityAttributesArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ApiUpdateEntityAttributesArgsToJson(this);

  final String? entity;
  final String? namespace;
  final List<Attribute?>? newAttributes;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ApiUpdateEntitySearchesArgs {
  ApiUpdateEntitySearchesArgs({this.entity, this.namespace, this.newSearches});

  factory ApiUpdateEntitySearchesArgs.fromJson(Map<String, dynamic> json) => _$ApiUpdateEntitySearchesArgsFromJson(json);

  Map<String, dynamic> toJson() => _$ApiUpdateEntitySearchesArgsToJson(this);

  final String? entity;
  final String? namespace;
  final List<Search?>? newSearches;
}

// ----- models -----

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Attribute {
  Attribute(
      {this.addable,
      this.dbName,
      this.dbType,
      this.defaultValue,
      this.foreignKey,
      this.goType,
      this.isArray,
      this.max,
      this.min,
      this.name,
      this.nullable,
      this.primaryKey,
      this.updatable});

  factory Attribute.fromJson(Map<String, dynamic> json) => _$AttributeFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeToJson(this);

  final bool? addable;
  final String? dbName;
  final String? dbType;
  final String? defaultValue;
  final String? foreignKey;
  final String? goType;
  final bool? isArray;
  final int? max;
  final int? min;
  final String? name;
  final bool? nullable;
  final bool? primaryKey;
  final bool? updatable;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CustomType {
  CustomType({this.dbType, this.goImport, this.goType});

  factory CustomType.fromJson(Map<String, dynamic> json) => _$CustomTypeFromJson(json);

  Map<String, dynamic> toJson() => _$CustomTypeToJson(this);

  final String? dbType;
  final String? goImport;
  final String? goType;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Entity {
  Entity({this.attributes, this.name, this.namespace, this.searches, this.table});

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

  Map<String, dynamic> toJson() => _$EntityToJson(this);

  final List<Attribute?>? attributes;
  final String? name;
  final String? namespace;
  final List<Search?>? searches;
  final String? table;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Namespace {
  Namespace({this.entities, this.name});

  factory Namespace.fromJson(Map<String, dynamic> json) => _$NamespaceFromJson(json);

  Map<String, dynamic> toJson() => _$NamespaceToJson(this);

  final List<Entity?>? entities;
  final String? name;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Project {
  Project({this.customTypes, this.goPgVer, this.languages, this.name, this.namespaces});

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  final List<CustomType?>? customTypes;
  final int? goPgVer;
  final List<String?>? languages;
  final String? name;
  final List<Namespace?>? namespaces;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Search {
  Search({this.attrName, this.name, this.searchType});

  factory Search.fromJson(Map<String, dynamic> json) => _$SearchFromJson(json);

  Map<String, dynamic> toJson() => _$SearchToJson(this);

  final String? attrName;
  final String? name;
  final String? searchType;
}
