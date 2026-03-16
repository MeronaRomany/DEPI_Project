import 'package:depi_project/core/networking/api_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioHelper {
 static late Dio dio;
  static   void init(){
   dio= Dio(BaseOptions(
      baseUrl: ApiConstant.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        "X-RapidAPI-Key":dotenv.env["API_KEY"],
        "X-RapidAPI-Host":"travel-advisor.p.rapidapi.com",
        "Content-Type":"application/json"
      }
    ));
  }

  static Future<Response> getData({required String endPoint,required Map<String,dynamic>? queryParameters})async{

   var response= await dio.get(endPoint, queryParameters:queryParameters);
   return response;
  }

}