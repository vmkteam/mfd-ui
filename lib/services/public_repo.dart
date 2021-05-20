import 'package:mfdui/services/api/api_client.dart';

class PublicRepo {
  PublicRepo(this._apiClient) {
    _goTypes = _Cached(() => _apiClient.public.types(PublicTypesArgs()).then((value) => value!.map((e) => e!).toList()));
    _dbTypes = _Cached(() => _apiClient.public.dBTypes(PublicDBTypesArgs()).then((value) => value!.map((e) => e!).toList()));
    _searchTypes = _Cached(() => _apiClient.public.searchTypes(PublicSearchTypesArgs()).then((value) => value!.map((e) => e!).toList()));
    _htmlTypes = _Cached(() => _apiClient.public.hTMLTypes(PublicHTMLTypesArgs()).then((value) => value!.map((e) => e!).toList()));
  }

  final ApiClient _apiClient;
  late final _Cached<List<String>> _goTypes;
  late final _Cached<List<String>> _dbTypes;
  late final _Cached<List<String>> _searchTypes;
  late final _Cached<List<String>> _htmlTypes;

  Future<Iterable<String>> goTypes(String query) async {
    final resp = await _goTypes.call();
    return resp.where((element) => element.contains(query));
  }

  Future<Iterable<String>> dbTypes(String query) async {
    final resp = await _dbTypes.call();
    return resp;
    //return resp.where((element) => element.contains(query));
  }

  Future<Iterable<String>> searchTypes(String query) async {
    final resp = await _searchTypes.call();
    return resp.where((element) => element.contains(query));
  }

  Future<Iterable<String>> htmlTypes(String query) async {
    final resp = await _htmlTypes.call();
    return resp;
    //return resp.where((element) => element.contains(query));
  }
}

class _Cached<T> {
  _Cached(this._call);

  final _CacheFunc<T> _call;
  T? _value;

  Future<T> call() async {
    if (_value != null) {
      return _value!;
    }
    return _call().then((value) {
      _value ??= value;
      return _value!;
    });
  }
}

typedef _CacheFunc<T> = Future<T> Function();
