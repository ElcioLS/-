import 'package:adf_cuidapet/app/core/helpers/text_formatter.dart';
import 'package:adf_cuidapet/app/core/ui/extensions/theme_extension.dart';
import 'package:adf_cuidapet/app/models/supplier_services_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../supplier_controller.dart';

class SupplierServiceWidget extends StatelessWidget {
  final SupplierServicesModel service;
  final SupplierController supplierController;

  const SupplierServiceWidget({
    super.key,
    required this.service,
    required this.supplierController,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.pets),
      ),
      title: Text(service.name),
      subtitle: Text(TextFormatter.formatReal(service.price)),
      trailing: Observer(
        builder: (_) {
          return IconButton(
            onPressed: () {
              supplierController.addOrRemoveService(service);
            },
            icon: supplierController.isServiceSelected(service)
                ? Icon(
                    Icons.remove_circle,
                    size: 30,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.add_circle,
                    size: 30,
                    color: context.primaryColor,
                  ),
          );
        },
      ),
    );
  }
}
