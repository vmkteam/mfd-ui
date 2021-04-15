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
      namespaces: apiProject.namespaces?.map((e) => Namespace.fromApi(e!)).toList() ?? List.empty(),
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

  factory Namespace.fromApi(api.Namespace namespace) {
    return Namespace(
      name: namespace.name!,
      entities: namespace.entities?.map((e) => Entity.fromApi(e!)).toList() ?? List.empty(),
    );
  }

  final String name;
  final List<Entity> entities;
}

class CustomType {
  CustomType({
    required this.dbType,
    required this.goImport,
    required this.goType,
  });

  factory CustomType.fromApi(api.CustomType ct) {
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

class Entity {
  Entity({
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
      attributes: entity.attributes?.map((e) => Attribute.fromApi(e!)).toList() ?? List.empty(),
      searches: entity.searches?.map((e) => Search.fromApi(e!)).toList() ?? List.empty(),
    );
  }

  final String name;
  final String namespace;
  final String table;
  final List<Attribute> attributes;
  final List<Search> searches;
}

class Attribute {}

class Search {}
