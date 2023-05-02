import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class BaseService extends ChangeNotifier {

  final storage = const FlutterSecureStorage();

  Future<Map<String,dynamic>> getJsonData( String baseUrl, String endpoint, {Map<String,String>? queryParams }) async {

    final url = Uri.https( baseUrl, endpoint, await _generateAuthenticationQuery(queryParams));
    final response = await http.get(url);

    return json.decode(response.body);
  }

  Future<Map<String,dynamic>> postJsonData( String baseUrl, String endpoint, String body , {Map<String,String>? queryParams }) async {

    final url = Uri.https( baseUrl, endpoint, await _generateAuthenticationQuery(queryParams));
    final response = await http.post(
      url,
      body: body
    );

    return json.decode(response.body);
  }

  Future<Map<String,dynamic>> putJsonData( String baseUrl, String endpoint, String body, {Map<String,String>? queryParams }) async {

    final url = Uri.https( baseUrl, endpoint, await _generateAuthenticationQuery(queryParams));
    final response = await http.put(url,body: body);

    return json.decode(response.body);
  }

  Future<Map<String,dynamic>> postBinaryFile( String baseUrl, String endpoint, File picture) async {

    final Map<String, String> params = {
      'uploadType': 'media',
      'name': picture.path.split('/').last,
    };

    final url = Uri.https( baseUrl, endpoint, params);

    final response = await http.post(
        url,
        body: await picture.readAsBytes()
    );

    return json.decode(response.body);
  }

  Future<Map<String, String>> _generateAuthenticationQuery (Map<String,String>? queryParams) async {
    if (queryParams!=null) {
      queryParams.addAll({
      'auth': await storage.read(key: 'token') ?? ''
      });
    } else {
      queryParams = {
        'auth': await storage.read(key: 'token') ?? ''
      };
    }
    return queryParams;
  }

}