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
      x[item.namespace!]!.add(item.entity!);
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
      attributes: entity.attributes
              ?.map(
                (e) => Attribute.fromApi(e!),
              )
              .toList() ??
          List.empty(),
      searches: entity.searches
              ?.map(
                (e) => Search.fromApi(e!),
              )
              .toList() ??
          List.empty(),
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
  Attribute({
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
      defaultValue: attribute.defaultVal ?? '',
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
