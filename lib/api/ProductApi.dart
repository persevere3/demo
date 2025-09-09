import './Request.dart';

class ProductApi {
  final Request request = Request();

  Future<dynamic> getProducts() async {
    final response = await request.dio.get('/interface/zh-CN/product/site_config.json');
    return response.data;
  }

  // Future<Map<String, dynamic>> getPost(int id) async {
  //   final response = await request.dio.get('/posts/$id');
  //   return response.data;
  // }
  //
  // Future<Map<String, dynamic>> createPost(Map<String, dynamic> data) async {
  //   final response = await request.dio.post('/posts', data: data);
  //   return response.data;
  // }
}