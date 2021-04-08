// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
