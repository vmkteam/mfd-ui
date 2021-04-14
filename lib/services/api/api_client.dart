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
      : api = _ServiceApi(client),
        xml = _ServiceXml(client);

  final _ServiceApi api;
  final _ServiceXml xml;
}

// ----- namespace classes -----

class _ServiceApi {
  _ServiceApi(this._client);

  final JSONRPCClient _client;

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

class _ServiceXml {
  _ServiceXml(this._client);

  final JSONRPCClient _client;

  Future<void> createProject(XmlCreateProjectArgs args) {
    return Future(() async {
      await _client.call('xml.createProject', args);
    });
  }

  Future<void> generateEntity(XmlGenerateEntityArgs args) {
    return Future(() async {
      await _client.call('xml.generateEntity', args);
    });
  }

  Future<void> loadEntity(XmlLoadEntityArgs args) {
    return Future(() async {
      await _client.call('xml.loadEntity', args);
    });
  }

  Future<void> loadProject(XmlLoadProjectArgs args) {
    return Future(() async {
      await _client.call('xml.loadProject', args);
    });
  }

  Future<void> saveEntity(XmlSaveEntityArgs args) {
    return Future(() async {
      await _client.call('xml.saveEntity', args);
    });
  }

  Future<void> saveProject(XmlSaveProjectArgs args) {
    return Future(() async {
      await _client.call('xml.saveProject', args);
    });
  }

  Future<List<String?>?> tables(XmlTablesArgs args) {
    return Future(() async {
      final response = await _client.call('xml.tables', args) as List?;
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
class XmlCreateProjectArgs {
  XmlCreateProjectArgs({this.filePath});

  factory XmlCreateProjectArgs.fromJson(Map<String, dynamic> json) => _$XmlCreateProjectArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlCreateProjectArgsToJson(this);

  final String? filePath;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlGenerateEntityArgs {
  XmlGenerateEntityArgs({this.filePath, this.namespace, this.table, this.url});

  factory XmlGenerateEntityArgs.fromJson(Map<String, dynamic> json) => _$XmlGenerateEntityArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlGenerateEntityArgsToJson(this);

  final String? filePath;
  final String? namespace;
  final String? table;
  final String? url;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlLoadEntityArgs {
  XmlLoadEntityArgs({this.entity, this.filePath, this.namespace});

  factory XmlLoadEntityArgs.fromJson(Map<String, dynamic> json) => _$XmlLoadEntityArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlLoadEntityArgsToJson(this);

  final String? entity;
  final String? filePath;
  final String? namespace;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlLoadProjectArgs {
  XmlLoadProjectArgs({this.filePath});

  factory XmlLoadProjectArgs.fromJson(Map<String, dynamic> json) => _$XmlLoadProjectArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlLoadProjectArgsToJson(this);

  final String? filePath;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlSaveEntityArgs {
  XmlSaveEntityArgs({this.contents, this.filePath});

  factory XmlSaveEntityArgs.fromJson(Map<String, dynamic> json) => _$XmlSaveEntityArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlSaveEntityArgsToJson(this);

  final String? contents;
  final String? filePath;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlSaveProjectArgs {
  XmlSaveProjectArgs({this.contents, this.filePath});

  factory XmlSaveProjectArgs.fromJson(Map<String, dynamic> json) => _$XmlSaveProjectArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlSaveProjectArgsToJson(this);

  final String? contents;
  final String? filePath;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class XmlTablesArgs {
  XmlTablesArgs({this.url});

  factory XmlTablesArgs.fromJson(Map<String, dynamic> json) => _$XmlTablesArgsFromJson(json);

  Map<String, dynamic> toJson() => _$XmlTablesArgsToJson(this);

  final String? url;
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
