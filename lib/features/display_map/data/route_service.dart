import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';


class RouteService {


  final Dio dio = Dio();



  Future<List<LatLng>> getRoute(
      LatLng start,
      LatLng end,
      ) async {



    final url =
        'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${end.longitude},${end.latitude}'
        '?overview=full&geometries=geojson';



    try {


      final response = await dio.get(url);



      final data = response.data;



      final coordinates =
      data['routes'][0]['geometry']['coordinates'];



      return coordinates.map<LatLng>((point) {


        return LatLng(

          point[1].toDouble(),

          point[0].toDouble(),

        );


      }).toList();



    } catch (e) {


      throw Exception(
        'Failed to load route: $e',
      );


    }


  }


}