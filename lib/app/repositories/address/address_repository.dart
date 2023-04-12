import 'package:adf_cuidapet/app/entities/address_entity.dart';
import 'package:adf_cuidapet/app/models/place_model.dart';

abstract class AddressRepository {
  Future<List<PlaceModel>> findAddressByGooglePlaces(String addressPattern);
  Future<List<AddressEntity>> getAddress();
  Future<int> saveAddress(AddressEntity entity);
  Future<void> deleteAll();
}
