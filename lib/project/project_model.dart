part of 'project.dart';

class Project {
  Project({
    required this.name,
    required this.namespaces,
    required this.languages,
    required this.customTypes,
  });

  factory Project.fromApi(api.Project apiProject) {
    return Project(
      name: apiProject.name!,
      customTypes: apiProject.customTypes?.map((e) => CustomType.fromApi(e!)).toList() ?? List.empty(),
      languages: apiProject.languages?.map((e) => e!).toList() ?? List.empty(),
      namespaces: Namespace.fromApi(apiProject.namespaces?.map((e) => e!).toList() ?? List.empty()),
    );
  }

  Project copyWith({
    String? name,
    List<Namespace>? namespaces,
    List<String>? languages,
    List<CustomType>? customTypes,
  }) {
    return Project(
      name: name ?? this.name,
      namespaces: namespaces ?? this.namespaces,
      languages: languages ?? this.languages,
      customTypes: customTypes ?? this.customTypes,
    );
  }

  final String name;
  final List<Namespace> namespaces;
  final List<String> languages;
  final List<CustomType> customTypes;
}

class Namespace {
  Namespace({
    required this.name,
    required this.entities,
  });

  static List<Namespace> fromApi(List<api.MfdNSMapping> mp) {
    final x = <String, List<String>>{};
    for (final item in mp) {
      if (!x.containsKey(item.namespace!)) {
        x[item.namespace!] = [];
      }
      x[item.namespace]!.add(item.entity!);
    }
    return x.entries.map((e) => Namespace(name: e.key, entities: e.value)).toList();
  }
  // factory Namespace.fromApi(api.Namespace namespace) {
  //   return Namespace(
  //     name: namespace.name!,
  //     entities: namespace.entities?.map((e) => Entity.fromApi(e!)).toList() ?? List.empty(),
  //   );
  // }

  final String name;
  final List<String> entities;
}

class CustomType {
  CustomType({
    required this.dbType,
    required this.goImport,
    required this.goType,
  });

  factory CustomType.fromApi(api.MfdCustomTypes ct) {
    return CustomType(
      dbType: ct.dbType!,
      goImport: ct.goImport!,
      goType: ct.goType!,
    );
  }

  final String dbType;
  final String goImport;
  final String goType;
}

class Entity extends Equatable {
  const Entity({
    required this.name,
    required this.namespace,
    required this.table,
    required this.attributes,
    required this.searches,
  });

  factory Entity.fromApi(api.Entity entity) {
    return Entity(
      name: entity.name!,
      namespace: entity.namespace!,
      table: entity.table!,
      attributes: entity.attributes!
          .map(
            (e) => Attribute.fromApi(e!),
          )
          .toList(),
      searches: entity.searches!
          .map(
            (e) => Search.fromApi(e!),
          )
          .toList(),
    );
  }

  api.Entity toApi() {
    return api.Entity(
      table: table,
      namespace: namespace,
      name: name,
      searches: searches.map((e) => e.toApi()).toList(),
      attributes: attributes.map((e) => e.toApi()).toList(),
    );
  }

  Entity copyWith({
    String? name,
    String? namespace,
    String? table,
    List<Attribute>? attributes,
    List<Search>? searches,
  }) {
    return Entity(
      name: name ?? this.name,
      namespace: namespace ?? this.namespace,
      table: table ?? this.table,
      attributes: attributes ?? this.attributes,
      searches: searches ?? this.searches,
    );
  }

  @override
  List<Object> get props => [name, namespace, table, attributes, searches];

  final String name;
  final String namespace;
  final String table;
  final List<Attribute> attributes;
  final List<Search> searches;
}

class Attribute {
  const Attribute({
    required this.addable,
    required this.dbName,
    required this.dbType,
    required this.defaultValue,
    required this.foreignKey,
    required this.goType,
    required this.isArray,
    required this.max,
    required this.min,
    required this.name,
    required this.nullable,
    required this.primaryKey,
    required this.updatable,
  });

  factory Attribute.fromApi(api.MfdAttributes attribute) {
    return Attribute(
      addable: attribute.addable!,
      dbName: attribute.dbName!,
      dbType: attribute.dbType!,
      defaultValue: attribute.defaultVal!,
      foreignKey: attribute.fk!,
      goType: attribute.goType!,
      isArray: attribute.isArray!,
      max: attribute.max!,
      min: attribute.min!,
      name: attribute.name!,
      nullable: attribute.nullable! == 'Yes',
      primaryKey: attribute.pk!,
      updatable: attribute.updatable!,
    );
  }

  @override
  String toString() {
    return 'Attribute{name: $name, dbName: $dbName, dbType: $dbType, goType: $goType, defaultValue: $defaultValue, primaryKey: $primaryKey, foreignKey: $foreignKey, isArray: $isArray, max: $max, min: $min, nullable: $nullable, addable: $addable, updatable: $updatable}';
  }

  api.MfdAttributes toApi() {
    return api.MfdAttributes(
      addable: addable,
      dbName: dbName,
      dbType: dbType,
      defaultVal: defaultValue,
      fk: foreignKey,
      goType: goType,
      isArray: isArray,
      max: max,
      min: min,
      name: name,
      nullable: nullable ? 'Yes' : 'No',
      pk: primaryKey,
      updatable: updatable,
    );
  }

  Attribute copyWith({
    String? name,
    String? dbName,
    String? dbType,
    String? goType,
    String? defaultValue,
    bool? primaryKey,
    String? foreignKey,
    bool? isArray,
    int? max,
    int? min,
    bool? nullable,
    bool? addable,
    bool? updatable,
  }) {
    return Attribute(
      name: name ?? this.name,
      dbName: dbName ?? this.dbName,
      dbType: dbType ?? this.dbType,
      goType: goType ?? this.goType,
      defaultValue: defaultValue ?? this.defaultValue,
      primaryKey: primaryKey ?? this.primaryKey,
      foreignKey: foreignKey ?? this.foreignKey,
      isArray: isArray ?? this.isArray,
      max: max ?? this.max,
      min: min ?? this.min,
      nullable: nullable ?? this.nullable,
      addable: addable ?? this.addable,
      updatable: updatable ?? this.updatable,
    );
  }

  final String name;
  final String dbName;
  final String dbType;
  final String goType;
  final String defaultValue;
  final bool primaryKey;
  final String foreignKey;
  final bool isArray;
  final int max;
  final int min;
  final bool nullable;
  final bool addable;
  final bool updatable;
}

class Search {
  const Search({
    required this.attrName,
    required this.name,
    required this.searchType,
  });

  factory Search.fromApi(api.MfdSearches search) {
    return Search(
      attrName: search.attrName!,
      name: search.name!,
      searchType: search.searchType!,
    );
  }

  api.MfdSearches toApi() {
    return api.MfdSearches(
      name: name,
      attrName: attrName,
      searchType: searchType,
    );
  }

  Search copyWith({
    String? name,
    String? attrName,
    String? searchType,
  }) {
    return Search(
      name: name ?? this.name,
      attrName: attrName ?? this.attrName,
      searchType: searchType ?? this.searchType,
    );
  }

  final String name;
  final String attrName;
  final String searchType;
}

class VTEntity {
  VTEntity({
    required this.name,
    required this.mode,
    required this.terminalPath,
    required this.attributes,
    required this.templates,
  });

  factory VTEntity.fromApi(api.VTEntity entity) {
    return VTEntity(
      name: entity.name!,
      mode: entity.mode!,
      terminalPath: entity.terminalPath!,
      attributes: entity.attributes!
          .map(
            (e) => VTAttribute.fromApi(e!),
          )
          .toList(),
      templates: entity.template!
          .map(
            (e) => VTTemplateAttribute.fromApi(e!),
          )
          .toList(),
    );
  }

  api.VTEntity toApi() {
    return api.VTEntity(
      name: name,
      mode: mode,
      terminalPath: terminalPath,
      attributes: attributes.map((e) => e.toApi()).toList(),
      template: templates.map((e) => e.toApi()).toList(),
    );
  }

  final String name;
  final String mode;
  final String terminalPath;
  final List<VTAttribute> attributes;
  final List<VTTemplateAttribute> templates;

  VTEntity copyWith({
    String? name,
    String? mode,
    String? terminalPath,
    List<VTAttribute>? attributes,
    List<VTTemplateAttribute>? templates,
  }) {
    return VTEntity(
      name: name ?? this.name,
      mode: mode ?? this.mode,
      terminalPath: terminalPath ?? this.terminalPath,
      attributes: attributes ?? this.attributes,
      templates: templates ?? this.templates,
    );
  }
}

class VTAttribute {
  const VTAttribute({
    required this.name,
    required this.attrName,
    required this.required,
    required this.summary,
    required this.search,
    required this.searchName,
    required this.validate,
    required this.max,
    required this.min,
  });

  factory VTAttribute.fromApi(api.MfdVTAttributes attribute) {
    return VTAttribute(
      name: attribute.name!,
      attrName: attribute.attrName!,
      required: attribute.required!,
      summary: attribute.summary!,
      search: attribute.search!,
      searchName: attribute.searchName!,
      validate: attribute.validate!,
      max: attribute.max!,
      min: attribute.min!,
    );
  }

  api.MfdVTAttributes toApi() {
    return api.MfdVTAttributes(
      name: name,
      attrName: attrName,
      required: required,
      summary: summary,
      search: search,
      searchName: searchName,
      validate: validate,
      max: max,
      min: min,
    );
  }

  final String name;
  final String attrName;
  final bool required;
  final bool summary;
  final bool search;
  final String searchName;
  final String validate;
  final int? max;
  final int? min;

  VTAttribute copyWith({
    String? name,
    String? attrName,
    bool? required,
    bool? summary,
    bool? search,
    String? searchName,
    String? validate,
    int? max,
    int? min,
  }) {
    return VTAttribute(
      name: name ?? this.name,
      attrName: attrName ?? this.attrName,
      required: required ?? this.required,
      summary: summary ?? this.summary,
      search: search ?? this.search,
      searchName: searchName ?? this.searchName,
      validate: validate ?? this.validate,
      max: max ?? this.max,
      min: min ?? this.min,
    );
  }
}

class VTTemplateAttribute {
  const VTTemplateAttribute({
    required this.name,
    required this.vtAttrName,
    required this.search,
    required this.fkOpts,
    required this.form,
    required this.list,
  });

  factory VTTemplateAttribute.fromApi(api.MfdTmplAttributes attribute) {
    return VTTemplateAttribute(
      name: attribute.name!,
      vtAttrName: attribute.vtAttrName!,
      search: attribute.search!,
      fkOpts: attribute.fkOpts!,
      form: attribute.form!,
      list: attribute.list!,
    );
  }

  api.MfdTmplAttributes toApi() {
    return api.MfdTmplAttributes(
      name: name,
      vtAttrName: vtAttrName,
      search: search,
      fkOpts: fkOpts,
      form: form,
      list: list,
    );
  }

  final String name;
  final String vtAttrName;
  final String search;
  final String fkOpts;
  final String form;
  final bool list;

  VTTemplateAttribute copyWith({
    String? name,
    String? vtAttrName,
    String? search,
    String? fkOpts,
    String? form,
    bool? list,
  }) {
    return VTTemplateAttribute(
      name: name ?? this.name,
      vtAttrName: vtAttrName ?? this.vtAttrName,
      search: search ?? this.search,
      fkOpts: fkOpts ?? this.fkOpts,
      form: form ?? this.form,
      list: list ?? this.list,
    );
  }
}
