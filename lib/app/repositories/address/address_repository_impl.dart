import 'package:adf_cuidapet/app/core/database/sqlite_connection_factory.dart';
import 'package:adf_cuidapet/app/core/exceptions/failure.dart';
import 'package:adf_cuidapet/app/core/helpers/environments.dart';
import 'package:adf_cuidapet/app/entities/address_entity.dart';
import 'package:adf_cuidapet/app/models/place_model.dart';
import 'package:google_places/google_places.dart';

import './address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final SqliteConnectionFactory _sqliteConnectionFactory;

  AddressRepositoryImpl(
      {required SqliteConnectionFactory sqliteConnectionFactory})
      : _sqliteConnectionFactory = sqliteConnectionFactory;
  @override
  Future<List<PlaceModel>> findAddressByGooglePlaces(
      String addressPattern) async {
    final googleApiKey = Environments.param('google_api_key');

    if (googleApiKey == null) {
      throw Failure(message: 'Google Api Key Not Found!');
    }
    final googlePlace = GooglePlaces(googleApiKey);
    final addressResult =
        await googlePlace.search.getTextSearch(addressPattern);

    final candidates = addressResult?.results;

    if (candidates != null) {
      return candidates.map<PlaceModel>((searchResult) {
        final location = searchResult.geometry?.location;
        final address = searchResult.formattedAddress;

        return PlaceModel(
          address: address ?? '',
          lat: location?.lat ?? 0,
          lng: location?.lng ?? 0,
        );
      }).toList();
    }
    return <PlaceModel>[];
  }

  @override
  Future<void> deleteAll() async {
    final sqliteConn = await _sqliteConnectionFactory.openConnection();
    await sqliteConn.delete('address');
  }

  @override
  Future<List<AddressEntity>> getAddress() async {
    final sqliteConn = await _sqliteConnectionFactory.openConnection();
    final result = await sqliteConn.rawQuery('select * from address');
    return result.map<AddressEntity>((a) => AddressEntity.fromMap(a)).toList();
  }

  @override
  Future<int> saveAddress(AddressEntity entity) async {
    final sqliteConn = await _sqliteConnectionFactory.openConnection();
    return await sqliteConn.rawInsert('insert into address values(?,?,?,?,?)', [
      null,
      entity.address,
      entity.lat,
      entity.lng,
      entity.additional,
    ]);
  }
}
