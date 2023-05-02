import 'dart:convert';

import 'package:flutter_curso_07_products_app/src/services/base_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService extends BaseService {

  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyDpFWUzXmuFR6Bft-Bi5DvqGltnqxBCE_w';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();


  Future<String?> createUser (String email, String password) async {

    final Map<String,dynamic> body = {
      'email': email,
      'password': password
    };

    final response = await super.postJsonData(_baseUrl, '/v1/accounts:signUp', json.encode(body), queryParams: {'key': _firebaseToken});

    if (response.containsKey('idToken')) {
      secureStorage.write(key: 'token', value: response['idToken']);
      secureStorage.write(key: 'refresh_token', value: response['refreshToken']);
      return null;
    } else {
      return response['error']['message'];
    }
  }

  Future<String?> authenticateUser (String email, String password) async {

    final Map<String,dynamic> body = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await super.postJsonData(_baseUrl, '/v1/accounts:signInWithPassword', json.encode(body), queryParams: {'key': _firebaseToken});

    if (response.containsKey('idToken')) {
      secureStorage.write(key: 'token', value: response['idToken']);
      secureStorage.write(key: 'refresh_token', value: response['refreshToken']);
      return null;
    } else {
      return response['error']['message'];
    }
  }

  Future<String> refreshToken () async {

    final Map<String,dynamic> body = {
      'grant_type': 'refresh_token',
      'refresh_token': await secureStorage.read(key: 'refresh_token'),
      'returnSecureToken': true
    };

    final response = await super.postJsonData(_baseUrl, '/v1/token', json.encode(body), queryParams: {'key': _firebaseToken});

    if (response.containsKey('idToken')) {
      secureStorage.write(key: 'token', value: response['idToken']);
      secureStorage.write(key: 'refresh_token', value: response['refreshToken']);
      return response['idToken'];
    }
    return '';
  }

  Future<String> validateToken () async {
    return await secureStorage.read(key: 'token')!=null ? await refreshToken() : '';
  }

  Future<void> logout () async {
    await secureStorage.deleteAll();
  }
}