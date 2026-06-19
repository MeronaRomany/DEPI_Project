import 'package:dio/dio.dart';

class OverpassApi {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 15),
    ),
  );

  Future<List<dynamic>> fetchPlaces(
    double south,
    double west,
    double north,
    double east,
  ) async {
    final query =
        '''
[out:json][timeout:25];
(
  node["tourism"~"museum|attraction|viewpoint"]($south,$west,$north,$east);
  way["tourism"~"museum|attraction|viewpoint"]($south,$west,$north,$east);
  relation["tourism"~"museum|attraction|viewpoint"]($south,$west,$north,$east);

  node["historic"~"monument|memorial"]($south,$west,$north,$east);
  way["historic"~"monument|memorial"]($south,$west,$north,$east);
  relation["historic"~"monument|memorial"]($south,$west,$north,$east);
);
out center;
''';

    try {
      final res = await dio.post(
        'https://overpass-api.de/api/interpreter',
        data: query,

      );
      
      final data = res.data;
      
      final elements = (data['elements'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      print("===============api$elements");
      return elements;

    } on DioException catch (e) {
      print("STATUS: ${e.response?.statusCode}");
      print("BODY: ${e.response?.data}");
      return [];
    }
  }
  }

