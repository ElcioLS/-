// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:adf_cuidapet/app/core/exceptions/failure.dart';
import 'package:adf_cuidapet/app/core/exceptions/user_exists_exception.dart';
import 'package:adf_cuidapet/app/core/logger/app_logger.dart';
import 'package:adf_cuidapet/app/core/rest_client/rest_client.dart';
import 'package:adf_cuidapet/app/core/rest_client/rest_client_exception.dart';
import 'package:adf_cuidapet/app/models/confirm_login_model.dart';
import 'package:adf_cuidapet/app/models/social_network_model.dart';
import 'package:adf_cuidapet/app/models/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient _restClient;
  final AppLogger _log;

  UserRepositoryImpl({
    required RestClient restClient,
    required AppLogger log,
  })  : _restClient = restClient,
        _log = log;

  @override
  Future<void> register(String email, String password) async {
    try {
      await _restClient.unauth().post('/auth/register', data: {
        'email': email,
        'password': password,
      });
    } on RestClientException catch (e, s) {
      if (e.statusCode == 400 &&
          e.response.data['message'].contains('Usuário já cadastrado')) {
        _log.error(e.error, e, s);
        throw UserExistsException();
      }

      _log.error('Erro ao cadastrar usuário', e, s);
      throw Failure(message: 'Erro ao registrar usuário');
    }
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final result = await _restClient.unauth().post(
        '/auth/',
        data: {
          'login': email,
          'password': password,
          'social_login': false,
          'supplier_user': false,
        },
      );

      return result.data['access_token'];
    } on RestClientException catch (e, s) {
      if (e.statusCode == 403) {
        throw Failure(
            message: 'Usuário inconsistente! Entre em contato com o suporte.');
      }

      _log.error('Erro ao realizar login', e, s);

      throw Failure(
          message: 'Erro ao realizar login! Tente novamente mais tarde.');
    }
  }

  @override
  Future<ConfirmLoginModel> confirmLogin() async {
    try {
      final deviceToken = await FirebaseMessaging.instance.getToken();
      final result = await _restClient.auth().patch(
        '/auth/confirm',
        data: {
          'ios_token': Platform.isIOS ? deviceToken : null,
          'android_token': Platform.isAndroid ? deviceToken : null,
        },
      );

      return ConfirmLoginModel.fromMap(result.data);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao confirmar login', e, s);
      throw Failure(message: 'Erro ao confirmar login');
    }
  }

  @override
  Future<UserModel> getUserLogged() async {
    try {
      final result = await _restClient.get('/user/');
      return UserModel.fromMap(result.data);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar usuário logado', e, s);
      throw Failure(message: 'Erro ao buscar dados do usuário logado');
    }
  }

  @override
  Future<String> loginSocial(SocialNetworkModel model) async {
    try {
      final result = await _restClient.unauth().post('/auth/', data: {
        'login': model.email,
        'social_login': true,
        'avatar': model.avatar,
        'social_type': model.type,
        'social_key': model.id,
        'supplier_user': false,
      });

      return result.data['access_token'];
    } on RestClientException catch (e, s) {
      if (e.statusCode == 403) {
        throw Failure(
            message: 'Usuário inconsistente! Entre em contato com o suporte.');
      }

      _log.error('Erro ao realizar login', e, s);

      throw Failure(
          message: 'Erro ao realizar login! Tente novamente mais tarde.');
    }
  }
}
