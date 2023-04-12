import 'package:adf_cuidapet/app/modules/core/supplier/supplier_core_module.dart';
import 'package:adf_cuidapet/app/modules/supplier/supplier_controller.dart';
import 'package:adf_cuidapet/app/modules/supplier/supplier_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SupplierModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton((i) => SupplierController(
              supplierService: i(),
              log: i(),
            ))
      ];

  @override
  List<Module> get imports => [
        SupplierCoreModule(),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => SupplierPage(
            supplierId: args.data,
          ),
        ),
      ];
}
