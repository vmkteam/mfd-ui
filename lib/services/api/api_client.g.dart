// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XmlvtGenerateEntityArgs _$XmlvtGenerateEntityArgsFromJson(
    Map<String, dynamic> json) {
  return XmlvtGenerateEntityArgs(
    entity: json['entity'] as String,
    namespace: json['namespace'] as String,
  );
}

Map<String, dynamic> _$XmlvtGenerateEntityArgsToJson(
        XmlvtGenerateEntityArgs instance) =>
    <String, dynamic>{
      'entity': instance.entity,
      'namespace': instance.namespace,
    };

ProjectOpenArgs _$ProjectOpenArgsFromJson(Map<String, dynamic> json) {
  return ProjectOpenArgs(
    connection: json['connection'] as String,
    filePath: json['filePath'] as String,
  );
}

Map<String, dynamic> _$ProjectOpenArgsToJson(ProjectOpenArgs instance) =>
    <String, dynamic>{
      'connection': instance.connection,
      'filePath': instance.filePath,
    };

ProjectPingArgs _$ProjectPingArgsFromJson(Map<String, dynamic> json) {
  return ProjectPingArgs();
}

Map<String, dynamic> _$ProjectPingArgsToJson(ProjectPingArgs instance) =>
    <String, dynamic>{};

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
    project: Project.fromJson(json['project'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProjectUpdateArgsToJson(ProjectUpdateArgs instance) =>
    <String, dynamic>{
      'project': instance.project.toJson(),
    };

XmlvtUpdateEntityArgs _$XmlvtUpdateEntityArgsFromJson(
    Map<String, dynamic> json) {
  return XmlvtUpdateEntityArgs(
    entity: json['entity'] == null
        ? null
        : VTEntity.fromJson(json['entity'] as Map<String, dynamic>),
    namespace: json['namespace'] as String,
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
  val['namespace'] = instance.namespace;
  return val;
}

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
    namespace: json['namespace'] as String,
    table: json['table'] as String,
  );
}

Map<String, dynamic> _$XmlGenerateEntityArgsToJson(
        XmlGenerateEntityArgs instance) =>
    <String, dynamic>{
      'namespace': instance.namespace,
      'table': instance.table,
    };

XmlLoadEntityArgs _$XmlLoadEntityArgsFromJson(Map<String, dynamic> json) {
  return XmlLoadEntityArgs(
    entity: json['entity'] as String,
    namespace: json['namespace'] as String,
  );
}

Map<String, dynamic> _$XmlLoadEntityArgsToJson(XmlLoadEntityArgs instance) =>
    <String, dynamic>{
      'entity': instance.entity,
      'namespace': instance.namespace,
    };

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

XmlvtLoadEntityArgs _$XmlvtLoadEntityArgsFromJson(Map<String, dynamic> json) {
  return XmlvtLoadEntityArgs(
    entity: json['entity'] as String,
    namespace: json['namespace'] as String,
  );
}

Map<String, dynamic> _$XmlvtLoadEntityArgsToJson(
        XmlvtLoadEntityArgs instance) =>
    <String, dynamic>{
      'entity': instance.entity,
      'namespace': instance.namespace,
    };

Entity _$EntityFromJson(Map<String, dynamic> json) {
  return Entity(
    attributes: (json['attributes'] as List<dynamic>)
        .map((e) => e == null
            ? null
            : MfdAttributes.fromJson(e as Map<String, dynamic>))
        .toList(),
    name: json['name'] as String,
    namespace: json['namespace'] as String,
    searches: (json['searches'] as List<dynamic>)
        .map((e) =>
            e == null ? null : MfdSearches.fromJson(e as Map<String, dynamic>))
        .toList(),
    table: json['table'] as String,
  );
}

Map<String, dynamic> _$EntityToJson(Entity instance) => <String, dynamic>{
      'attributes': instance.attributes.map((e) => e?.toJson()).toList(),
      'name': instance.name,
      'namespace': instance.namespace,
      'searches': instance.searches.map((e) => e?.toJson()).toList(),
      'table': instance.table,
    };

MfdAttributes _$MfdAttributesFromJson(Map<String, dynamic> json) {
  return MfdAttributes(
    addable: json['addable'] as bool,
    dbName: json['dbName'] as String,
    dbType: json['dbType'] as String,
    defaultVal: json['defaultVal'] as String,
    disablePointer: json['disablePointer'] as bool,
    fk: json['fk'] as String,
    goType: json['goType'] as String,
    isArray: json['isArray'] as bool,
    max: json['max'] as int,
    min: json['min'] as int,
    name: json['name'] as String,
    nullable: json['nullable'] as String,
    pk: json['pk'] as bool,
    updatable: json['updatable'] as bool,
  );
}

Map<String, dynamic> _$MfdAttributesToJson(MfdAttributes instance) =>
    <String, dynamic>{
      'addable': instance.addable,
      'dbName': instance.dbName,
      'dbType': instance.dbType,
      'defaultVal': instance.defaultVal,
      'disablePointer': instance.disablePointer,
      'fk': instance.fk,
      'goType': instance.goType,
      'isArray': instance.isArray,
      'max': instance.max,
      'min': instance.min,
      'name': instance.name,
      'nullable': instance.nullable,
      'pk': instance.pk,
      'updatable': instance.updatable,
    };

MfdCustomTypes _$MfdCustomTypesFromJson(Map<String, dynamic> json) {
  return MfdCustomTypes(
    dbType: json['dbType'] as String,
    goImport: json['goImport'] as String,
    goType: json['goType'] as String,
  );
}

Map<String, dynamic> _$MfdCustomTypesToJson(MfdCustomTypes instance) =>
    <String, dynamic>{
      'dbType': instance.dbType,
      'goImport': instance.goImport,
      'goType': instance.goType,
    };

MfdNSMapping _$MfdNSMappingFromJson(Map<String, dynamic> json) {
  return MfdNSMapping(
    entity: json['entity'] as String,
    namespace: json['namespace'] as String,
  );
}

Map<String, dynamic> _$MfdNSMappingToJson(MfdNSMapping instance) =>
    <String, dynamic>{
      'entity': instance.entity,
      'namespace': instance.namespace,
    };

MfdSearches _$MfdSearchesFromJson(Map<String, dynamic> json) {
  return MfdSearches(
    attrName: json['attrName'] as String,
    goType: json['goType'] as String,
    name: json['name'] as String,
    searchType: json['searchType'] as String,
  );
}

Map<String, dynamic> _$MfdSearchesToJson(MfdSearches instance) =>
    <String, dynamic>{
      'attrName': instance.attrName,
      'goType': instance.goType,
      'name': instance.name,
      'searchType': instance.searchType,
    };

MfdTmplAttributes _$MfdTmplAttributesFromJson(Map<String, dynamic> json) {
  return MfdTmplAttributes(
    fkOpts: json['fkOpts'] as String,
    form: json['form'] as String,
    list: json['list'] as bool,
    name: json['name'] as String,
    search: json['search'] as String,
    vtAttrName: json['vtAttrName'] as String,
  );
}

Map<String, dynamic> _$MfdTmplAttributesToJson(MfdTmplAttributes instance) =>
    <String, dynamic>{
      'fkOpts': instance.fkOpts,
      'form': instance.form,
      'list': instance.list,
      'name': instance.name,
      'search': instance.search,
      'vtAttrName': instance.vtAttrName,
    };

MfdVTAttributes _$MfdVTAttributesFromJson(Map<String, dynamic> json) {
  return MfdVTAttributes(
    attrName: json['attrName'] as String,
    max: json['max'] as int,
    min: json['min'] as int,
    name: json['name'] as String,
    required: json['required'] as bool,
    search: json['search'] as bool,
    searchName: json['searchName'] as String,
    summary: json['summary'] as bool,
    validate: json['validate'] as String,
  );
}

Map<String, dynamic> _$MfdVTAttributesToJson(MfdVTAttributes instance) =>
    <String, dynamic>{
      'attrName': instance.attrName,
      'max': instance.max,
      'min': instance.min,
      'name': instance.name,
      'required': instance.required,
      'search': instance.search,
      'searchName': instance.searchName,
      'summary': instance.summary,
      'validate': instance.validate,
    };

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return Project(
    customTypes: (json['customTypes'] as List<dynamic>)
        .map((e) => e == null
            ? null
            : MfdCustomTypes.fromJson(e as Map<String, dynamic>))
        .toList(),
    goPGVer: json['goPGVer'] as int,
    languages:
        (json['languages'] as List<dynamic>).map((e) => e as String?).toList(),
    name: json['name'] as String,
    namespaces: (json['namespaces'] as List<dynamic>)
        .map((e) =>
            e == null ? null : MfdNSMapping.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'customTypes': instance.customTypes.map((e) => e?.toJson()).toList(),
      'goPGVer': instance.goPGVer,
      'languages': instance.languages,
      'name': instance.name,
      'namespaces': instance.namespaces.map((e) => e?.toJson()).toList(),
    };

VTEntity _$VTEntityFromJson(Map<String, dynamic> json) {
  return VTEntity(
    attributes: (json['attributes'] as List<dynamic>)
        .map((e) => e == null
            ? null
            : MfdVTAttributes.fromJson(e as Map<String, dynamic>))
        .toList(),
    mode: json['mode'] as String,
    name: json['name'] as String,
    template: (json['template'] as List<dynamic>)
        .map((e) => e == null
            ? null
            : MfdTmplAttributes.fromJson(e as Map<String, dynamic>))
        .toList(),
    terminalPath: json['terminalPath'] as String,
  );
}

Map<String, dynamic> _$VTEntityToJson(VTEntity instance) => <String, dynamic>{
      'attributes': instance.attributes.map((e) => e?.toJson()).toList(),
      'mode': instance.mode,
      'name': instance.name,
      'template': instance.template.map((e) => e?.toJson()).toList(),
      'terminalPath': instance.terminalPath,
    };
