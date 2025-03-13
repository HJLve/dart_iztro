import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

/// 地理位置信息
class GeoLocation {
  final String name;
  final String displayName;
  final double latitude;
  final double longitude;

  GeoLocation({
    required this.name,
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'GeoLocation{name: $name, displayName: $displayName, latitude: $latitude, longitude: $longitude}';
  }
}

/// 城市数据模型
///
/// 在这个模型中：
/// - 省级行政区作为顶层对象
/// - city字段包含该省下所有城市
/// - area字段包含城市下所有区县
class CityModel {
  final String name;
  final double? longitude;
  final double? latitude;
  final List<CityModel>? city;
  final List<String>? area;

  CityModel({
    required this.name,
    this.longitude,
    this.latitude,
    this.city,
    this.area,
  });

  /// 从JSON创建模型
  factory CityModel.fromJson(Map<String, dynamic> json) {
    List<CityModel>? cityList;
    List<String>? areaList;

    // 解析城市列表
    if (json['city'] != null) {
      try {
        cityList =
            (json['city'] as List)
                .map((child) => CityModel.fromJson(child))
                .toList();
      } catch (e) {
        print('解析城市数据出错: $e');
        cityList = [];
      }
    }

    // 解析区县列表
    if (json['area'] != null) {
      try {
        areaList =
            (json['area'] as List).map((area) => area.toString()).toList();
      } catch (e) {
        print('解析区县数据出错: $e');
        areaList = [];
      }
    }

    String name = '';
    double? longitude;
    double? latitude;

    try {
      name = json['name'] as String;
    } catch (e) {
      print('解析名称出错: $e');
      name = json['name']?.toString() ?? 'Unknown';
    }

    // 尝试解析经度，但现在可能不存在
    try {
      if (json['log'] != null) {
        longitude = double.parse(json['log'].toString());
      }
    } catch (e) {
      print('解析经度出错: $e');
    }

    // 尝试解析纬度，但现在可能不存在
    try {
      if (json['lat'] != null) {
        latitude = double.parse(json['lat'].toString());
      }
    } catch (e) {
      print('解析纬度出错: $e');
    }

    return CityModel(
      name: name,
      longitude: longitude,
      latitude: latitude,
      city: cityList,
      area: areaList,
    );
  }
}

/// 地理位置查询服务，用于根据地址获取经纬度信息
class GeoLookupService {
  /// OpenStreetMap Nominatim API地址
  final String _nominatimApiUrl = 'https://nominatim.openstreetmap.org/search';

  /// Dio实例
  final Dio _dio;

  /// 本地城市数据缓存
  List<CityModel>? _localCityData;

  /// 本地城市经纬度数据缓存
  List<Map<String, dynamic>>? _cityLatData;

  /// 构造函数，初始化Dio实例
  GeoLookupService() : _dio = Dio() {
    // 配置基本选项 - 增加超时时间
    _dio.options.connectTimeout = const Duration(seconds: 30); // 增加到30秒
    _dio.options.receiveTimeout = const Duration(seconds: 30); // 增加到30秒
    _dio.options.sendTimeout = const Duration(seconds: 30); // 增加到30秒
    _dio.options.headers = {
      'User-Agent': 'DartIztroApp/1.0', // Nominatim API要求提供User-Agent
    };

    // 添加简化的日志拦截器，只记录错误和响应
    _dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: true, error: true),
    );

    // 预加载本地城市数据
    _loadLocalCityData();

    // 预加载城市经纬度数据
    _loadCityLatData();
  }

  /// 加载本地城市数据
  Future<void> _loadLocalCityData() async {
    try {
      // 尝试加载资源
      String? jsonData;
      try {
        // 优先从插件包资源路径加载
        jsonData = await rootBundle.loadString(
          'packages/dart_iztro/assets/data/city.json',
        );
        print('成功从packages/dart_iztro/assets/data/city.json加载城市数据');
      } catch (packageError) {
        try {
          // 再尝试从直接路径加载
          jsonData = await rootBundle.loadString('assets/data/city.json');
          print('成功从assets/data/city.json加载城市数据');
        } catch (assetError) {
          // 尝试其他可能的路径
          try {
            jsonData = await rootBundle.loadString('../assets/data/city.json');
            print('成功从../assets/data/city.json加载城市数据');
          } catch (otherPathError) {
            print('所有可能的城市数据资源路径均加载失败');
            print(
              '加载失败详情: \n - packages/dart_iztro/assets/data/city.json: $packageError\n - assets/data/city.json: $assetError\n - ../assets/data/city.json: $otherPathError',
            );

            // 尝试更多可能的路径
            print('尝试其他可能的路径...');
            final assetPathList = [
              'assets/city.json',
              'data/city.json',
              'city.json',
            ];

            bool dataLoaded = false;
            for (final path in assetPathList) {
              try {
                print('尝试加载: $path');
                jsonData = await rootBundle.loadString(path);
                print('成功从 $path 加载城市数据');
                dataLoaded = true;
                break; // 成功加载，跳出循环
              } catch (e) {
                print('加载 $path 失败: $e');
                // 继续尝试下一个路径
              }
            }

            // 如果所有路径都失败了
            if (!dataLoaded) {
              print('所有路径都加载失败');
              _localCityData = [];
              return;
            }
          }
        }
      }

      // 确保jsonData不为null
      if (jsonData == null) {
        print('加载城市数据失败: 未能获取数据');
        _localCityData = [];
        return;
      }

      // 解析JSON数据
      final List<dynamic> jsonList = json.decode(jsonData);
      _localCityData =
          jsonList.map((json) => CityModel.fromJson(json)).toList();
      print('本地城市数据加载成功，共 ${_localCityData?.length ?? 0} 个省级行政区');
    } catch (e) {
      print('加载或解析本地城市数据失败: $e');
      _localCityData = [];
    }
  }

  /// 加载城市经纬度数据
  Future<void> _loadCityLatData() async {
    try {
      String? jsonData;
      try {
        // 优先从插件包资源路径加载
        jsonData = await rootBundle.loadString(
          'packages/dart_iztro/assets/data/city_lat.json',
        );
        print('成功从packages/dart_iztro/assets/data/city_lat.json加载城市经纬度数据');
      } catch (packageError) {
        try {
          // 再尝试从直接路径加载
          jsonData = await rootBundle.loadString('assets/data/city_lat.json');
          print('成功从assets/data/city_lat.json加载城市经纬度数据');
        } catch (e) {
          print('加载city_lat.json失败，所有路径均尝试失败: $e');
          return;
        }
      }

      final List<dynamic> rawData = json.decode(jsonData);
      _cityLatData = [];

      // 处理数据，提取所有地区名称和经纬度
      for (var province in rawData) {
        if (province is Map<String, dynamic>) {
          _extractGeoData(province);
        }
      }

      print('城市经纬度数据加载成功，共 ${_cityLatData?.length ?? 0} 个地区');
    } catch (e) {
      print('加载或解析城市经纬度数据失败: $e');
      _cityLatData = [];
    }
  }

  /// 递归提取地理数据
  void _extractGeoData(Map<String, dynamic> data) {
    String name = data['name'] ?? '';
    String? log = data['log'];
    String? lat = data['lat'];

    if (name.isNotEmpty && log != null && lat != null) {
      _cityLatData?.add({'name': name, 'log': log, 'lat': lat});
    }

    // 递归处理子项
    if (data['children'] is List) {
      for (var child in data['children']) {
        if (child is Map<String, dynamic>) {
          _extractGeoData(child);
        }
      }
    }
  }

  /// 根据名称查找地区经纬度
  Map<String, dynamic>? _findLocationByName(String name) {
    if (_cityLatData == null || _cityLatData!.isEmpty) {
      return null;
    }

    for (var location in _cityLatData!) {
      if (location['name'] == name) {
        return location;
      }
    }

    return null;
  }

  /// 从本地数据搜索城市
  Future<GeoLocation?> _searchLocalCityData(String address) async {
    if (_localCityData == null) {
      try {
        await _loadLocalCityData();
      } catch (e) {
        print('加载本地城市数据失败: $e');
        return null;
      }
    }

    if (_localCityData == null || _localCityData!.isEmpty) {
      print('本地城市数据为空或无效，无法进行地址查询');
      return null;
    }

    print('开始在本地数据中搜索地址: "$address"');
    print('本地数据中共有 ${_localCityData!.length} 个省级行政区');

    // 输出一些本地数据的信息，便于调试
    print('省级行政区列表: ${_localCityData!.map((p) => p.name).join(', ')}');

    // 默认经纬度（如果没有找到数据）
    final defaultLongitude = 116.4074;
    final defaultLatitude = 39.9042;

    // 省级搜索
    for (var province in _localCityData!) {
      if (address.contains(province.name)) {
        print('匹配到省级行政区: ${province.name}');

        // 尝试查找城市
        if (province.city != null && province.city!.isNotEmpty) {
          print(
            '${province.name}下有${province.city!.length}个城市: ${province.city!.map((c) => c.name).join(', ')}',
          );

          // 搜索匹配的城市
          List<CityModel> matchedCities = [];
          for (var city in province.city!) {
            if (address.contains(city.name)) {
              matchedCities.add(city);

              // 进一步搜索区县
              if (city.area != null && city.area!.isNotEmpty) {
                print(
                  '${city.name}下有${city.area!.length}个区县: ${city.area!.join(', ')}',
                );

                // 寻找匹配的区县
                List<String> matchedAreas = [];
                for (var area in city.area!) {
                  if (address.contains(area) && area != "其他") {
                    matchedAreas.add(area);
                  }
                }

                // 如果找到匹配的区县
                if (matchedAreas.isNotEmpty) {
                  // 按名称长度排序，选择最长匹配（通常更具体）
                  matchedAreas.sort((a, b) => b.length.compareTo(a.length));
                  final bestAreaMatch = matchedAreas.first;

                  print('在${city.name}下找到区县: $bestAreaMatch');

                  // 尝试从city_lat.json中查找区县的经纬度
                  double areaLat = city.latitude ?? defaultLatitude;
                  double areaLong = city.longitude ?? defaultLongitude;

                  final areaGeoData = _findLocationByName(bestAreaMatch);
                  if (areaGeoData != null) {
                    try {
                      areaLat = double.parse(areaGeoData['lat']);
                      areaLong = double.parse(areaGeoData['log']);
                      print(
                        '从city_lat.json获取到区县经纬度: 经度=$areaLong, 纬度=$areaLat',
                      );
                    } catch (e) {
                      print('解析区县经纬度出错: $e, 使用城市经纬度作为备选');
                    }
                  } else {
                    print('在city_lat.json中未找到区县[$bestAreaMatch]的数据，使用城市经纬度');
                  }

                  // 使用查找到的经纬度
                  return GeoLocation(
                    name: bestAreaMatch,
                    displayName:
                        '$bestAreaMatch, ${city.name}, ${province.name}',
                    latitude: areaLat,
                    longitude: areaLong,
                  );
                }
              }
            }
          }

          // 如果找到匹配的城市
          if (matchedCities.isNotEmpty) {
            // 按名称长度排序
            matchedCities.sort(
              (a, b) => b.name.length.compareTo(a.name.length),
            );
            final bestCityMatch = matchedCities.first;

            print('在${province.name}下找到城市: ${bestCityMatch.name}');
            return GeoLocation(
              name: bestCityMatch.name,
              displayName: '${bestCityMatch.name}, ${province.name}',
              latitude: bestCityMatch.latitude ?? defaultLatitude,
              longitude: bestCityMatch.longitude ?? defaultLongitude,
            );
          }
        }

        // 如果没找到具体城市，返回省级数据
        return GeoLocation(
          name: province.name,
          displayName: province.name,
          latitude: province.latitude ?? defaultLatitude,
          longitude: province.longitude ?? defaultLongitude,
        );
      }
    }

    print('未找到匹配的省级行政区，尝试直接匹配城市和区县');

    // 创建一个包含所有可能匹配的列表
    List<Map<String, dynamic>> allMatches = [];

    // 搜索所有城市和区县
    for (var province in _localCityData!) {
      if (province.city != null) {
        for (var city in province.city!) {
          // 检查城市名是否匹配
          if (address.contains(city.name)) {
            allMatches.add({
              'type': 'city',
              'name': city.name,
              'displayName': '${city.name}, ${province.name}',
              'latitude': city.latitude ?? defaultLatitude,
              'longitude': city.longitude ?? defaultLongitude,
              'level': 2, // 城市级别
              'nameLength': city.name.length,
            });
          }

          // 检查区县名是否匹配
          if (city.area != null) {
            for (var area in city.area!) {
              if (address.contains(area) && area != "其他") {
                // 尝试从city_lat.json中查找区县的经纬度
                double areaLat = city.latitude ?? defaultLatitude;
                double areaLong = city.longitude ?? defaultLongitude;

                final areaGeoData = _findLocationByName(area);
                if (areaGeoData != null) {
                  try {
                    areaLat = double.parse(areaGeoData['lat']);
                    areaLong = double.parse(areaGeoData['log']);
                    print(
                      '从city_lat.json获取到区县经纬度: $area 经度=$areaLong, 纬度=$areaLat',
                    );
                  } catch (e) {
                    print('解析区县经纬度出错: $e, 使用城市经纬度作为备选');
                  }
                } else {
                  print('在city_lat.json中未找到区县[$area]的数据，使用城市经纬度');
                }

                allMatches.add({
                  'type': 'area',
                  'name': area,
                  'displayName': '$area, ${city.name}, ${province.name}',
                  'latitude': areaLat,
                  'longitude': areaLong,
                  'level': 3, // 区县级别
                  'nameLength': area.length,
                });
              }
            }
          }
        }
      }
    }

    if (allMatches.isNotEmpty) {
      // 首先按级别排序（区县 > 城市），然后按名称长度排序（更长的名称通常更具体）
      allMatches.sort((a, b) {
        if (a['level'] != b['level']) {
          return b['level'] - a['level']; // 优先返回更详细级别
        }
        return b['nameLength'] - a['nameLength']; // 同级别时，优先返回名称更长的
      });

      final bestMatch = allMatches.first;
      print('找到最佳匹配: ${bestMatch['name']} (${bestMatch['type']})');

      return GeoLocation(
        name: bestMatch['name'],
        displayName: bestMatch['displayName'],
        latitude: bestMatch['latitude'],
        longitude: bestMatch['longitude'],
      );
    }

    print('在本地数据中未找到匹配的地址: "$address"');
    return null;
  }

  /// 查询地址获取地理位置信息
  /// [address] 要查询的地址
  /// 返回地理位置信息，如果未找到则返回null
  Future<GeoLocation?> lookupAddress(String address) async {
    if (address.isEmpty) {
      print('地址查询失败: 地址为空');
      return null;
    }

    try {
      // 优先尝试使用在线API查询
      // 打印完整URI，方便调试
      final encodedAddress = Uri.encodeComponent(address);
      final fullUrl = '$_nominatimApiUrl?q=$encodedAddress&format=json';
      print('完整URI: $fullUrl');

      // 构建请求参数
      final queryParameters = {'q': address, 'format': 'json'};

      print('搜索地址: $address');

      // 发送GET请求，并设置更长的超时时间
      final response = await _dio.get(
        _nominatimApiUrl,
        queryParameters: queryParameters,
        options: Options(
          // 为这个特定请求设置更长的超时时间
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      print('API响应状态码: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Dio已经自动将JSON转换为List
        final List<dynamic> data = responseData;
        print('API返回数据条数: ${data.length}');

        if (data.isNotEmpty) {
          final result = data.first;
          print('选取的结果: $result');

          // 确保lat和lon字段存在
          if (result['lat'] == null || result['lon'] == null) {
            print('API返回的数据缺少经度或纬度信息');
            return null;
          }

          final double lat = double.parse(result['lat']);
          final double lon = double.parse(result['lon']);

          print('解析后的经纬度: 纬度=$lat, 经度=$lon');

          final location = GeoLocation(
            name: result['name'] ?? address,
            displayName: result['display_name'] ?? address,
            latitude: lat,
            longitude: lon,
          );

          print('创建的地理位置对象: $location');
          return location;
        } else {
          print('API返回的数据为空，尝试从本地数据中查找');
          return await _searchLocalCityData(address);
        }
      } else {
        print('API请求失败，状态码: ${response.statusCode}，尝试从本地数据中查找');
        return await _searchLocalCityData(address);
      }
    } on DioException catch (e) {
      print('地址查询失败，Dio异常: ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout) {
        print('连接超时，请检查网络连接或使用VPN');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print('接收数据超时，服务器响应过慢');
      } else if (e.type == DioExceptionType.sendTimeout) {
        print('发送数据超时，请检查网络连接');
      }
      print('详细错误: ${e.error}');
      if (e.response != null) {
        print('错误响应: ${e.response!.data}');
      }

      // 从本地数据中查找
      print('尝试从本地数据中查找地址信息');
      final localResult = await _searchLocalCityData(address);
      if (localResult != null) {
        return localResult;
      }

      // 如果实在找不到，可以给出一个友好提示
      print('在本地数据中未找到匹配的地址: $address');
      return null;
    } catch (e) {
      print('地址查询失败，发生异常: $e');
      // 尝试从本地数据中查找
      return await _searchLocalCityData(address);
    }
  }
}
