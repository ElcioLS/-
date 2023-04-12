import 'package:adf_cuidapet/app/core/life_cycle/controller_life_cycle.dart';
import 'package:adf_cuidapet/app/core/ui/widgets/loader.dart';
import 'package:adf_cuidapet/app/core/ui/widgets/messages.dart';
import 'package:adf_cuidapet/app/entities/address_entity.dart';
import 'package:adf_cuidapet/app/models/supplier_category_model.dart';
import 'package:adf_cuidapet/app/models/supplier_nearby_me_model.dart';
import 'package:adf_cuidapet/app/services/address/address_service.dart';
import 'package:adf_cuidapet/app/services/supplier/supplier_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

enum SupplierPageType { list, grid }

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store, ControllerLifeCycle {
  final AddressService _addressService;
  final SupplierService _supplierService;

  @readonly
  AddressEntity? _addressEntity;

  @readonly
  var _listCategories = <SupplierCategoryModel>[];

  @readonly
  var _supplierPageTypeSelected = SupplierPageType.list;

  @readonly
  var _listSuppliersByAddress = <SupplierNearbyMeModel>[];

  @readonly
  var _listSuppliersByAddressCache = <SupplierNearbyMeModel>[];

  var _nameSearchText = '';

  @readonly
  SupplierCategoryModel? _supplierCategoryFilterSelected;

  late ReactionDisposer findSupplierReactionDisposer;

  HomeControllerBase(
      {required AddressService addressService,
      required SupplierService supplierService})
      : _addressService = addressService,
        _supplierService = supplierService;

  @override
  void onInit([Map<String, dynamic>? params]) {
    findSupplierReactionDisposer = reaction((_) => _addressEntity, (address) {
      findSupplierByAddress();
    });
  }

  @override
  void dispose() {
    findSupplierReactionDisposer();
  }

  @override
  Future<void> onReady() async {
    try {
      Loader.show();
      await _getAddressSelected();
      await _getCategories();
    } finally {
      Loader.hide();
    }
  }

  @action
  Future<void> _getAddressSelected() async {
    _addressEntity ??= await _addressService.getAddressSelected();

    if (_addressEntity == null) {
      await goToAddressPage();
    }
  }

  @action
  Future<void> goToAddressPage() async {
    final address = await Modular.to.pushNamed<AddressEntity>('/address/');

    if (_addressEntity != null) {
      _addressEntity = address;
    }
  }

  @action
  Future<void> _getCategories() async {
    try {
      final categories = await _supplierService.getCategories();
      _listCategories = [...categories];
    } catch (e) {
      Messages.alert('Erro ao buscar as categorias');
      throw Exception();
    }
  }

  @action
  void changeTapSupplier(SupplierPageType supplierPageType) {
    _supplierPageTypeSelected = supplierPageType;
  }

  @action
  Future<void> findSupplierByAddress() async {
    if (_addressEntity != null) {
      final suppliers = await _supplierService.findNearBy(_addressEntity!);
      _listSuppliersByAddress = [...suppliers];
      _listSuppliersByAddressCache = [...suppliers];
      filterSupplier();
    } else {
      Messages.alert(
          'Para buscar Petshops é necessários que selecione um endereço');
    }
  }

  @action
  void filterSupplierCategory(SupplierCategoryModel category) {
    if (_supplierCategoryFilterSelected == category) {
      _supplierCategoryFilterSelected = null;
    } else {
      _supplierCategoryFilterSelected = category;
    }
    filterSupplier();
  }

  void filterSupplierByName(String name) {
    _nameSearchText = name;
    filterSupplier();
  }

  @action
  void filterSupplier() {
    var suppliers = [..._listSuppliersByAddressCache];
    if (_supplierCategoryFilterSelected != null) {
      suppliers = suppliers
          .where((supplier) =>
              supplier.category == _supplierCategoryFilterSelected?.id)
          .toList();
    }

    if (_nameSearchText.isNotEmpty) {
      suppliers = suppliers
          .where((supplier) => supplier.name
              .toLowerCase()
              .contains(_nameSearchText.toLowerCase()))
          .toList();
    }

    _listSuppliersByAddress = [...suppliers];
  }
}
