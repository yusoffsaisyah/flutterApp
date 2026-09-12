import 'package:http/http.dart' as http;
import 'package:flutter_application_1/genmodel.dart';

class RemoteService {

  Future<List<Product>?> getProducts() async{
    var client = http.Client();

    var uri = Uri.parse('https://dummyjson.com/products?limit=10&skip=10');
    var response = await client.get(uri);
    if (response.statusCode == 200){
      var json = response.body;
      return dataFromJson(json).products;
    }
  }

}