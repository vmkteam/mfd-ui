// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiLoadProjectArgs _$ApiLoadProjectArgsFromJson(Map<String, dynamic> json) {
  return ApiLoadProjectArgs(
    filepath: json['filepath'] as String?,
  );
}

Map<String, dynamic> _$ApiLoadProjectArgsToJson(ApiLoadProjectArgs instance) {
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
    name: json['name'] as String?,
  );
}

Map<String, dynamic> _$ApiProjectArgsToJson(ApiProjectArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  return val;
}

XmlCreateProjectArgs _$XmlCreateProjectArgsFromJson(Map<String, dynamic> json) {
  return XmlCreateProjectArgs(
    filePath: json['filePath'] as String?,
  );
}

Map<String, dynamic> _$XmlCreateProjectArgsToJson(
    XmlCreateProjectArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('filePath', instance.filePath);
  return val;
}

XmlGenerateEntityArgs _$XmlGenerateEntityArgsFromJson(
    Map<String, dynamic> json) {
  return XmlGenerateEntityArgs(
    filePath: json['filePath'] as String?,
    namespace: json['namespace'] as String?,
    table: json['table'] as String?,
    url: json['url'] as String?,
  );
}

Map<String, dynamic> _$XmlGenerateEntityArgsToJson(
    XmlGenerateEntityArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('filePath', instance.filePath);
  writeNotNull('namespace', instance.namespace);
  writeNotNull('table', instance.table);
  writeNotNull('url', instance.url);
  return val;
}

XmlLoadEntityArgs _$XmlLoadEntityArgsFromJson(Map<String, dynamic> json) {
  return XmlLoadEntityArgs(
    entity: json['entity'] as String?,
    filePath: json['filePath'] as String?,
    namespace: json['namespace'] as String?,
  );
}

Map<String, dynamic> _$XmlLoadEntityArgsToJson(XmlLoadEntityArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('entity', instance.entity);
  writeNotNull('filePath', instance.filePath);
  writeNotNull('namespace', instance.namespace);
  return val;
}

XmlLoadProjectArgs _$XmlLoadProjectArgsFromJson(Map<String, dynamic> json) {
  return XmlLoadProjectArgs(
    filePath: json['filePath'] as String?,
  );
}

Map<String, dynamic> _$XmlLoadProjectArgsToJson(XmlLoadProjectArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('filePath', instance.filePath);
  return val;
}

XmlSaveEntityArgs _$XmlSaveEntityArgsFromJson(Map<String, dynamic> json) {
  return XmlSaveEntityArgs(
    contents: json['contents'] as String?,
    filePath: json['filePath'] as String?,
  );
}

Map<String, dynamic> _$XmlSaveEntityArgsToJson(XmlSaveEntityArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('contents', instance.contents);
  writeNotNull('filePath', instance.filePath);
  return val;
}

XmlSaveProjectArgs _$XmlSaveProjectArgsFromJson(Map<String, dynamic> json) {
  return XmlSaveProjectArgs(
    contents: json['contents'] as String?,
    filePath: json['filePath'] as String?,
  );
}

Map<String, dynamic> _$XmlSaveProjectArgsToJson(XmlSaveProjectArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('contents', instance.contents);
  writeNotNull('filePath', instance.filePath);
  return val;
}

XmlTablesArgs _$XmlTablesArgsFromJson(Map<String, dynamic> json) {
  return XmlTablesArgs(
    url: json['url'] as String?,
  );
}

Map<String, dynamic> _$XmlTablesArgsToJson(XmlTablesArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('url', instance.url);
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
