import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ukuya_assessment/data/models/post_model.dart';

class PostRepositories {
  // Fetch data with try and catch block
  Future<List<PostModel>> fetchPost() async {
    final items = <PostModel>[];

    try {
      // Assuming the client has internet
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      // Assuming [http.get] works fine
      final responseJson = json.decode(response.body) as List<dynamic>;

      // Iterate the response and add it with factory method to the list
      for (var i = 0; i < responseJson.length; i++) {
        items.add(
          PostModel.fromJson(json: responseJson[i] as Map<String, dynamic>),
        );
      }
    } catch (e) {
      // Otherwise, just throw Exception
      throw Exception(e);
    }

    return items;
  }
}
