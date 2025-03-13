class Province {
  final String name;
  final double longitude;
  final double latitude;
  final List<City> cities;

  Province({
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.cities,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    List<City> cityList = [];
    if (json['children'] != null) {
      cityList = List<City>.from(
        json['children'].map((city) => City.fromJson(city)),
      );
    }

    return Province(
      name: json['name'] ?? '',
      longitude: double.tryParse(json['log'] ?? '0.0') ?? 0.0,
      latitude: double.tryParse(json['lat'] ?? '0.0') ?? 0.0,
      cities: cityList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'log': longitude.toString(),
      'lat': latitude.toString(),
      'children': cities.map((city) => city.toJson()).toList(),
    };
  }
}

class City {
  final String name;
  final double longitude;
  final double latitude;

  City({required this.name, required this.longitude, required this.latitude});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] ?? '',
      longitude: double.tryParse(json['log'] ?? '0.0') ?? 0.0,
      latitude: double.tryParse(json['lat'] ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'log': longitude.toString(),
      'lat': latitude.toString(),
    };
  }
}
