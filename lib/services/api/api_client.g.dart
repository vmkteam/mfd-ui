// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectCurrentArgs _$ProjectCurrentArgsFromJson(Map<String, dynamic> json) {
  return ProjectCurrentArgs();
}

Map<String, dynamic> _$ProjectCurrentArgsToJson(ProjectCurrentArgs instance) =>
    <String, dynamic>{};

ProjectOpenArgs _$ProjectOpenArgsFromJson(Map<String, dynamic> json) {
  return ProjectOpenArgs(
    connection: json['connection'] as String?,
    filePath: json['filePath'] as String?,
  );
}

Map<String, dynamic> _$ProjectOpenArgsToJson(ProjectOpenArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('connection', instance.connection);
  writeNotNull('filePath', instance.filePath);
  return val;
}

ProjectSaveArgs _$ProjectSaveArgsFromJson(Map<String, dynamic> json) {
  return ProjectSaveArgs();
}

Map<String, dynamic> _$ProjectSaveArgsToJson(ProjectSaveArgs instance) =>
    <String, dynamic>{};

ProjectTablesArgs _$ProjectTablesArgsFromJson(Map<String, dynamic> json) {
  return ProjectTablesArgs();
}

Map<String, dynamic> _$ProjectTablesArgsToJson(ProjectTablesArgs instance) =>
    <String, dynamic>{};

ProjectUpdateArgs _$ProjectUpdateArgsFromJson(Map<String, dynamic> json) {
  return ProjectUpdateArgs(
    project: json['project'] == null
        ? null
        : Project.fromJson(json['project'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProjectUpdateArgsToJson(ProjectUpdateArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('project', instance.project?.toJson());
  return val;
}

PublicDBTypesArgs _$PublicDBTypesArgsFromJson(Map<String, dynamic> json) {
  return PublicDBTypesArgs();
}

Map<String, dynamic> _$PublicDBTypesArgsToJson(PublicDBTypesArgs instance) =>
    <String, dynamic>{};

PublicGoPGVersionsArgs _$PublicGoPGVersionsArgsFromJson(
    Map<String, dynamic> json) {
  return PublicGoPGVersionsArgs();
}

Map<String, dynamic> _$PublicGoPGVersionsArgsToJson(
        PublicGoPGVersionsArgs instance) =>
    <String, dynamic>{};

PublicModesArgs _$PublicModesArgsFromJson(Map<String, dynamic> json) {
  return PublicModesArgs();
}

Map<String, dynamic> _$PublicModesArgsToJson(PublicModesArgs instance) =>
    <String, dynamic>{};

PublicPingArgs _$PublicPingArgsFromJson(Map<String, dynamic> json) {
  return PublicPingArgs();
}

Map<String, dynamic> _$PublicPingArgsToJson(PublicPingArgs instance) =>
    <String, dynamic>{};

PublicSearchTypesArgs _$PublicSearchTypesArgsFromJson(
    Map<String, dynamic> json) {
  return PublicSearchTypesArgs();
}

Map<String, dynamic> _$PublicSearchTypesArgsToJson(
        PublicSearchTypesArgs instance) =>
    <String, dynamic>{};

PublicTypesArgs _$PublicTypesArgsFromJson(Map<String, dynamic> json) {
  return PublicTypesArgs();
}

Map<String, dynamic> _$PublicTypesArgsToJson(PublicTypesArgs instance) =>
    <String, dynamic>{};

XmlGenerateEntityArgs _$XmlGenerateEntityArgsFromJson(
    Map<String, dynamic> json) {
  return XmlGenerateEntityArgs(
    namespace: json['namespace'] as String?,
    table: json['table'] as String?,
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

  writeNotNull('namespace', instance.namespace);
  writeNotNull('table', instance.table);
  return val;
}

XmlGenerateModelCodeArgs _$XmlGenerateModelCodeArgsFromJson(
    Map<String, dynamic> json) {
  return XmlGenerateModelCodeArgs(
    entity: json['entity'] == null
        ? null
        : Entity.fromJson(json['entity'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$XmlGenerateModelCodeArgsToJson(
    XmlGenerateModelCodeArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('entity', instance.entity?.toJson());
  return val;
}

XmlGenerateSearchModelCodeArgs _$XmlGenerateSearchModelCodeArgsFromJson(
    Map<String, dynamic> json) {
  return XmlGenerateSearchModelCodeArgs(
    entity: json['entity'] == null
        ? null
        : Entity.fromJson(json['entity'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$XmlGenerateSearchModelCodeArgsToJson(
    XmlGenerateSearchModelCodeArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('entity', instance.entity?.toJson());
  return val;
}

XmlLoadEntityArgs _$XmlLoadEntityArgsFromJson(Map<String, dynamic> json) {
  return XmlLoadEntityArgs(
    entity: json['entity'] as String?,
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
  writeNotNull('namespace', instance.namespace);
  return val;
}

XmlUpdateEntityArgs _$XmlUpdateEntityArgsFromJson(Map<String, dynamic> json) {
  return XmlUpdateEntityArgs(
    entity: json['entity'] == null
        ? null
        : Entity.fromJson(json['entity'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$XmlUpdateEntityArgsToJson(XmlUpdateEntityArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('entity', instance.entity?.toJson());
  return val;
}

XmlvtGenerateEntityArgs _$XmlvtGenerateEntityArgsFromJson(
    Map<String, dynamic> json) {
  return XmlvtGenerateEntityArgs(
    entity: json['entity'] as String?,
    namespace: json['namespace'] as String?,
  );
}

Map<String, dynamic> _$XmlvtGenerateEntityArgsToJson(
    XmlvtGenerateEntityArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('entity', instance.entity);
  writeNotNull('namespace', instance.namespace);
  return val;
}

XmlvtLoadEntityArgs _$XmlvtLoadEntityArgsFromJson(Map<String, dynamic> json) {
  return XmlvtLoadEntityArgs(
    entity: json['entity'] as String?,
    namespace: json['namespace'] as String?,
  );
}

Map<String, dynamic> _$XmlvtLoadEntityArgsToJson(XmlvtLoadEntityArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('entity', instance.entity);
  writeNotNull('namespace', instance.namespace);
  return val;
}

XmlvtUpdateEntityArgs _$XmlvtUpdateEntityArgsFromJson(
    Map<String, dynamic> json) {
  return XmlvtUpdateEntityArgs(
    entity: json['entity'] == null
        ? null
        : VTEntity.fromJson(json['entity'] as Map<String, dynamic>),
    namespace: json['namespace'] as String?,
  );
}

Map<String, dynamic> _$XmlvtUpdateEntityArgsToJson(
    XmlvtUpdateEntityArgs instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('entity', instance.entity?.toJson());
  writeNotNull('namespace', instance.namespace);
  return val;
}

Entity _$EntityFromJson(Map<String, dynamic> json) {
  return Entity(
    attributes: (json['attributes'] as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : MfdAttributes.fromJson(e as Map<String, dynamic>))
        .toList(),
    name: json['name'] as String?,
    namespace: json['namespace'] as String?,
    searches: (json['searches'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : MfdSearches.fromJson(e as Map<String, dynamic>))
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

MfdAttributes _$MfdAttributesFromJson(Map<String, dynamic> json) {
  return MfdAttributes(
    addable: json['addable'] as bool?,
    dbName: json['dbName'] as String?,
    dbType: json['dbType'] as String?,
    defaultVal: json['defaultVal'] as String?,
    disablePointer: json['disablePointer'] as bool?,
    fk: json['fk'] as String?,
    goType: json['goType'] as String?,
    isArray: json['isArray'] as bool?,
    max: json['max'] as int?,
    min: json['min'] as int?,
    name: json['name'] as String?,
    nullable: json['nullable'] as String?,
    pk: json['pk'] as bool?,
    updatable: json['updatable'] as bool?,
  );
}

Map<String, dynamic> _$MfdAttributesToJson(MfdAttributes instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('addable', instance.addable);
  writeNotNull('dbName', instance.dbName);
  writeNotNull('dbType', instance.dbType);
  writeNotNull('defaultVal', instance.defaultVal);
  writeNotNull('disablePointer', instance.disablePointer);
  writeNotNull('fk', instance.fk);
  writeNotNull('goType', instance.goType);
  writeNotNull('isArray', instance.isArray);
  writeNotNull('max', instance.max);
  writeNotNull('min', instance.min);
  writeNotNull('name', instance.name);
  writeNotNull('nullable', instance.nullable);
  writeNotNull('pk', instance.pk);
  writeNotNull('updatable', instance.updatable);
  return val;
}

MfdCustomTypes _$MfdCustomTypesFromJson(Map<String, dynamic> json) {
  return MfdCustomTypes(
    dbType: json['dbType'] as String?,
    goImport: json['goImport'] as String?,
    goType: json['goType'] as String?,
  );
}

Map<String, dynamic> _$MfdCustomTypesToJson(MfdCustomTypes instance) {
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

MfdNSMapping _$MfdNSMappingFromJson(Map<String, dynamic> json) {
  return MfdNSMapping(
    entity: json['entity'] as String?,
    namespace: json['namespace'] as String?,
  );
}

Map<String, dynamic> _$MfdNSMappingToJson(MfdNSMapping instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('entity', instance.entity);
  writeNotNull('namespace', instance.namespace);
  return val;
}

MfdSearches _$MfdSearchesFromJson(Map<String, dynamic> json) {
  return MfdSearches(
    attrName: json['attrName'] as String?,
    goType: json['goType'] as String?,
    name: json['name'] as String?,
    searchType: json['searchType'] as String?,
  );
}

Map<String, dynamic> _$MfdSearchesToJson(MfdSearches instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('attrName', instance.attrName);
  writeNotNull('goType', instance.goType);
  writeNotNull('name', instance.name);
  writeNotNull('searchType', instance.searchType);
  return val;
}

MfdTmplAttributes _$MfdTmplAttributesFromJson(Map<String, dynamic> json) {
  return MfdTmplAttributes(
    fkOpts: json['fkOpts'] as String?,
    form: json['form'] as String?,
    list: json['list'] as bool?,
    name: json['name'] as String?,
    search: json['search'] as String?,
    vtAttrName: json['vtAttrName'] as String?,
  );
}

Map<String, dynamic> _$MfdTmplAttributesToJson(MfdTmplAttributes instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('fkOpts', instance.fkOpts);
  writeNotNull('form', instance.form);
  writeNotNull('list', instance.list);
  writeNotNull('name', instance.name);
  writeNotNull('search', instance.search);
  writeNotNull('vtAttrName', instance.vtAttrName);
  return val;
}

MfdVTAttributes _$MfdVTAttributesFromJson(Map<String, dynamic> json) {
  return MfdVTAttributes(
    attrName: json['attrName'] as String?,
    max: json['max'] as int?,
    min: json['min'] as int?,
    name: json['name'] as String?,
    required: json['required'] as bool?,
    search: json['search'] as bool?,
    searchName: json['searchName'] as String?,
    summary: json['summary'] as bool?,
    validate: json['validate'] as String?,
  );
}

Map<String, dynamic> _$MfdVTAttributesToJson(MfdVTAttributes instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('attrName', instance.attrName);
  writeNotNull('max', instance.max);
  writeNotNull('min', instance.min);
  writeNotNull('name', instance.name);
  writeNotNull('required', instance.required);
  writeNotNull('search', instance.search);
  writeNotNull('searchName', instance.searchName);
  writeNotNull('summary', instance.summary);
  writeNotNull('validate', instance.validate);
  return val;
}

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return Project(
    customTypes: (json['customTypes'] as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : MfdCustomTypes.fromJson(e as Map<String, dynamic>))
        .toList(),
    goPGVer: json['goPGVer'] as int?,
    languages: (json['languages'] as List<dynamic>?)
        ?.map((e) => e as String?)
        .toList(),
    name: json['name'] as String?,
    namespaces: (json['namespaces'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : MfdNSMapping.fromJson(e as Map<String, dynamic>))
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
  writeNotNull('goPGVer', instance.goPGVer);
  writeNotNull('languages', instance.languages);
  writeNotNull('name', instance.name);
  writeNotNull(
      'namespaces', instance.namespaces?.map((e) => e?.toJson()).toList());
  return val;
}

VTEntity _$VTEntityFromJson(Map<String, dynamic> json) {
  return VTEntity(
    attributes: (json['attributes'] as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : MfdVTAttributes.fromJson(e as Map<String, dynamic>))
        .toList(),
    mode: json['mode'] as String?,
    name: json['name'] as String?,
    template: (json['template'] as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : MfdTmplAttributes.fromJson(e as Map<String, dynamic>))
        .toList(),
    terminalPath: json['terminalPath'] as String?,
  );
}

Map<String, dynamic> _$VTEntityToJson(VTEntity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'attributes', instance.attributes?.map((e) => e?.toJson()).toList());
  writeNotNull('mode', instance.mode);
  writeNotNull('name', instance.name);
  writeNotNull('template', instance.template?.map((e) => e?.toJson()).toList());
  writeNotNull('terminalPath', instance.terminalPath);
  return val;
}
