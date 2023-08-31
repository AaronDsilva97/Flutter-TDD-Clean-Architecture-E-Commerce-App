import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../core/constant/string.dart';
import '../../../domain/usecases/user/sign_in_usecase.dart';
import '../../../domain/usecases/user/sign_up_usecase.dart';
import '../../models/user/authentication_response_model.dart';

abstract class UserRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<AuthenticationResponseModel> signIn(SignInParams params);

  /// Throws a [ServerException] for all error codes.
  Future<AuthenticationResponseModel> signUp(SignUpParams params);
}

class AuthenticationRemoteDataSourceImpl
    implements UserRemoteDataSource {
  final http.Client client;
  AuthenticationRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthenticationResponseModel> signIn(params) => _authenticate(
        '$baseUrl/authentication/local/sign-in',
        {
          'identifier': params.username,
          'password': params.password,
        },
      );

  @override
  Future<AuthenticationResponseModel> signUp(params) => _authenticate(
        '$baseUrl/authentication/local/sign-up',
        {
          'firstName': params.firstName,
          'lastName': params.lastName,
          'email': params.username,
          'password': params.password,
        },
      );

  Future<AuthenticationResponseModel> _authenticate(
      String url, Map<String, dynamic> body) async {
    final response = await client.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body));
    if (response.statusCode == 200) {
      return authenticationResponseModelFromJson(response.body);
    } else {
      throw ServerException();
    }
  }
}