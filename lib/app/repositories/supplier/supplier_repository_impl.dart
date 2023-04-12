import 'package:adf_cuidapet/app/core/exceptions/failure.dart';
import 'package:adf_cuidapet/app/core/logger/app_logger.dart';
import 'package:adf_cuidapet/app/core/rest_client/rest_client.dart';
import 'package:adf_cuidapet/app/core/rest_client/rest_client_exception.dart';
import 'package:adf_cuidapet/app/entities/address_entity.dart';
import 'package:adf_cuidapet/app/models/supplier_category_model.dart';
import 'package:adf_cuidapet/app/models/supplier_model.dart';
import 'package:adf_cuidapet/app/models/supplier_nearby_me_model.dart';
import 'package:adf_cuidapet/app/models/supplier_services_model.dart';

import './supplier_repository.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final RestClient _restClient;
  final AppLogger _log;

  SupplierRepositoryImpl(
      {required RestClient restClient, required AppLogger log})
      : _restClient = restClient,
        _log = log;

  @override
  Future<List<SupplierCategoryModel>> getCategories() async {
    try {
      final result = await _restClient.auth().get('/categories/');
      return result.data
          ?.map<SupplierCategoryModel>(
            (categoryResponse) =>
                SupplierCategoryModel.fromMap(categoryResponse),
          )
          .toList();
    } on RestClientException catch (e, s) {
      const message = 'Erro ao buscar categorias de fornecedores';
      _log.error(message, e, s);
      throw Failure(message: message);
    }
  }

  @override
  Future<List<SupplierNearbyMeModel>> findNearBy(AddressEntity address) async {
    try {
      final result =
          await _restClient.auth().get('/suppliers/', queryParameters: {
        'lat': address.lat,
        'lng': address.lng,
      });
      return result.data
          ?.map<SupplierNearbyMeModel>((supplierResponse) =>
              SupplierNearbyMeModel.fromMap(supplierResponse))
          .toList();
    } on RestClientException catch (e, s) {
      const message =
          'Erro ao buscar fornecedores próximos a minha localização';
      _log.error(message, e, s);
      throw Failure(message: message);
    }
  }

  @override
  Future<SupplierModel> findById(int id) async {
    try {
      final result = await _restClient.auth().get('/suppliers/$id');
      return SupplierModel.fromMap(result.data);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar dados do fornecedor por id', e, s);
      throw Failure(message: 'Erro ao buscar dados do fornecedor por id');
    }
  }

  @override
  Future<List<SupplierServicesModel>> findServices(int supplierId) async {
    try {
      final result =
          await _restClient.auth().get('/suppliers/$supplierId/services');
      return result.data
              ?.map<SupplierServicesModel>(
                  (jService) => SupplierServicesModel.fromMap(jService))
              .toList() ??
          <SupplierServicesModel>[];
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar serviços do fornecedor', e, s);
      throw Failure(message: 'Erro ao buscar serviços do fornecedor');
    }
  }
}
