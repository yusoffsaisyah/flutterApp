import 'package:http/http.dart' as http;
import 'package:flutter_application_1/genmodel.dart';

class RemoteService {

  Future<Data?> getData(int limit,int skip) async{
    var client = http.Client();

    var uri = Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip');
    var response = await client.get(uri);
    print(response.statusCode);
    if (response.statusCode == 200){
      var json = response.body;
      return dataFromJson(json);
    }
  }

  Future<List<Product>?> getProducts(int limit,int skip) async{
    var client = http.Client();

    var uri = Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip');
    var response = await client.get(uri);
    print(response.statusCode);
    if (response.statusCode == 200){
      var json = response.body;
      return dataFromJson(json).products;
    }
  }



}