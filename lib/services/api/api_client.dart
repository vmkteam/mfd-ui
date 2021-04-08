// Code generated from zenrpc smd. DO NOT EDIT.

// To update this file:
// 1. Pull fresh version and start apisvc locally on 8080 port.
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
  ApiClient(JSONRPCClient client) : xml = _ServiceXml(client);

  final _ServiceXml xml;
}

// ----- namespace classes -----

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
