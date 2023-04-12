import 'package:adf_cuidapet/app/repositories/supplier/supplier_repository.dart';
import 'package:adf_cuidapet/app/repositories/supplier/supplier_repository_impl.dart';
import 'package:adf_cuidapet/app/services/supplier/supplier_service.dart';
import 'package:adf_cuidapet/app/services/supplier/supplier_service_impl.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SupplierCoreModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<SupplierRepository>(
          (i) => SupplierRepositoryImpl(
            restClient: i(),
            log: i(),
          ),
          export: true,
        ),
        Bind.lazySingleton<SupplierService>(
            (i) => SupplierServiceImpl(supplierRepository: i()),
            export: true),
      ];
}
