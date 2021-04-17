// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiOpenProjectArgs _$ApiOpenProjectArgsFromJson(Map<String, dynamic> json) {
  return ApiOpenProjectArgs(
    filepath: json['filepath'] as String?,
  );
}

Map<String, dynamic> _$ApiOpenProjectArgsToJson(ApiOpenProjectArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('filepath', instance.filepath);
  return val;
}

ApiPingArgs _$ApiPingArgsFromJson(Map<String, dynamic> json) {
  return ApiPingArgs();
}

Map<String, dynamic> _$ApiPingArgsToJson(ApiPingArgs instance) =>
    <String, dynamic>{};

ApiProjectArgs _$ApiProjectArgsFromJson(Map<String, dynamic> json) {
  return ApiProjectArgs(
    filepath: json['filepath'] as String?,
  );
}

Map<String, dynamic> _$ApiProjectArgsToJson(ApiProjectArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('filepath', instance.filepath);
  return val;
}

ApiProjectxArgs _$ApiProjectxArgsFromJson(Map<String, dynamic> json) {
  return ApiProjectxArgs();
}

Map<String, dynamic> _$ApiProjectxArgsToJson(ApiProjectxArgs instance) =>
    <String, dynamic>{};

ApiSaveProjectArgs _$ApiSaveProjectArgsFromJson(Map<String, dynamic> json) {
  return ApiSaveProjectArgs();
}

Map<String, dynamic> _$ApiSaveProjectArgsToJson(ApiSaveProjectArgs instance) =>
    <String, dynamic>{};

ApiUpdateEntityAttributesArgs _$ApiUpdateEntityAttributesArgsFromJson(
    Map<String, dynamic> json) {
  return ApiUpdateEntityAttributesArgs(
    entity: json['entity'] as String?,
    namespace: json['namespace'] as String?,
    newAttributes: (json['newAttributes'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : Attribute.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ApiUpdateEntityAttributesArgsToJson(
    ApiUpdateEntityAttributesArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('entity', instance.entity);
  writeNotNull('namespace', instance.namespace);
  writeNotNull('newAttributes',
      instance.newAttributes?.map((e) => e?.toJson()).toList());
  return val;
}

ApiUpdateEntitySearchesArgs _$ApiUpdateEntitySearchesArgsFromJson(
    Map<String, dynamic> json) {
  return ApiUpdateEntitySearchesArgs(
    entity: json['entity'] as String?,
    namespace: json['namespace'] as String?,
    newSearches: (json['newSearches'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : Search.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ApiUpdateEntitySearchesArgsToJson(
    ApiUpdateEntitySearchesArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('entity', instance.entity);
  writeNotNull('namespace', instance.namespace);
  writeNotNull(
      'newSearches', instance.newSearches?.map((e) => e?.toJson()).toList());
  return val;
}

Attribute _$AttributeFromJson(Map<String, dynamic> json) {
  return Attribute(
    addable: json['addable'] as bool?,
    dbName: json['dbName'] as String?,
    dbType: json['dbType'] as String?,
    defaultValue: json['defaultValue'] as String?,
    foreignKey: json['foreignKey'] as String?,
    goType: json['goType'] as String?,
    isArray: json['isArray'] as bool?,
    max: json['max'] as int?,
    min: json['min'] as int?,
    name: json['name'] as String?,
    nullable: json['nullable'] as bool?,
    primaryKey: json['primaryKey'] as bool?,
    updatable: json['updatable'] as bool?,
  );
}

Map<String, dynamic> _$AttributeToJson(Attribute instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('addable', instance.addable);
  writeNotNull('dbName', instance.dbName);
  writeNotNull('dbType', instance.dbType);
  writeNotNull('defaultValue', instance.defaultValue);
  writeNotNull('foreignKey', instance.foreignKey);
  writeNotNull('goType', instance.goType);
  writeNotNull('isArray', instance.isArray);
  writeNotNull('max', instance.max);
  writeNotNull('min', instance.min);
  writeNotNull('name', instance.name);
  writeNotNull('nullable', instance.nullable);
  writeNotNull('primaryKey', instance.primaryKey);
  writeNotNull('updatable', instance.updatable);
  return val;
}

CustomType _$CustomTypeFromJson(Map<String, dynamic> json) {
  return CustomType(
    dbType: json['dbType'] as String?,
    goImport: json['goImport'] as String?,
    goType: json['goType'] as String?,
  );
}

Map<String, dynamic> _$CustomTypeToJson(CustomType instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('dbType', instance.dbType);
  writeNotNull('goImport', instance.goImport);
  writeNotNull('goType', instance.goType);
  return val;
}

Entity _$EntityFromJson(Map<String, dynamic> json) {
  return Entity(
    attributes: (json['attributes'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : Attribute.fromJson(e as Map<String, dynamic>))
        .toList(),
    name: json['name'] as String?,
    namespace: json['namespace'] as String?,
    searches: (json['searches'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : Search.fromJson(e as Map<String, dynamic>))
        .toList(),
    table: json['table'] as String?,
  );
}

Map<String, dynamic> _$EntityToJson(Entity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'attributes', instance.attributes?.map((e) => e?.toJson()).toList());
  writeNotNull('name', instance.name);
  writeNotNull('namespace', instance.namespace);
  writeNotNull('searches', instance.searches?.map((e) => e?.toJson()).toList());
  writeNotNull('table', instance.table);
  return val;
}

Namespace _$NamespaceFromJson(Map<String, dynamic> json) {
  return Namespace(
    entities: (json['entities'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : Entity.fromJson(e as Map<String, dynamic>))
        .toList(),
    name: json['name'] as String?,
  );
}

Map<String, dynamic> _$NamespaceToJson(Namespace instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('entities', instance.entities?.map((e) => e?.toJson()).toList());
  writeNotNull('name', instance.name);
  return val;
}

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return Project(
    customTypes: (json['customTypes'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : CustomType.fromJson(e as Map<String, dynamic>))
        .toList(),
    goPgVer: json['goPgVer'] as int?,
    languages: (json['languages'] as List<dynamic>?)
        ?.map((e) => e as String?)
        .toList(),
    name: json['name'] as String?,
    namespaces: (json['namespaces'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : Namespace.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ProjectToJson(Project instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'customTypes', instance.customTypes?.map((e) => e?.toJson()).toList());
  writeNotNull('goPgVer', instance.goPgVer);
  writeNotNull('languages', instance.languages);
  writeNotNull('name', instance.name);
  writeNotNull(
      'namespaces', instance.namespaces?.map((e) => e?.toJson()).toList());
  return val;
}

Search _$SearchFromJson(Map<String, dynamic> json) {
  return Search(
    attrName: json['attrName'] as String?,
    name: json['name'] as String?,
    searchType: json['searchType'] as String?,
  );
}

Map<String, dynamic> _$SearchToJson(Search instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('attrName', instance.attrName);
  writeNotNull('name', instance.name);
  writeNotNull('searchType', instance.searchType);
  return val;
}
