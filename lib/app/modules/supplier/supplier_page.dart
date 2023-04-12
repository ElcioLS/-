import 'package:adf_cuidapet/app/core/life_cycle/page_life_cycle_state.dart';
import 'package:adf_cuidapet/app/core/ui/extensions/theme_extension.dart';
import 'package:adf_cuidapet/app/modules/supplier/widgets/supplier_detail.dart';
import 'package:adf_cuidapet/app/modules/supplier/widgets/supplier_service_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'supplier_controller.dart';

class SupplierPage extends StatefulWidget {
  final int _supplierId;

  const SupplierPage({Key? key, required int supplierId})
      : _supplierId = supplierId,
        super(key: key);

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState
    extends PageLifeCycleState<SupplierController, SupplierPage> {
  late ScrollController _scrollController;
  bool sliverCollapsed = false;
  final sliverCollapsedVN = ValueNotifier(false);

  @override
  Map<String, dynamic>? get params => {
        'supplierId': widget._supplierId,
      };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 180 &&
          !_scrollController.position.outOfRange) {
        sliverCollapsedVN.value = true;
      } else if (_scrollController.offset <= 180 &&
          !_scrollController.position.outOfRange) {
        sliverCollapsedVN.value = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Observer(
        builder: (_) {
          return AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: controller.totalServicesSelected > 0 ? 1 : 0,
            child: FloatingActionButton.extended(
              label: Text('Realizar agendamento.'),
              onPressed: controller.goToSchedule,
              icon: Icon(Icons.schedule),
              backgroundColor: context.primaryColor,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Observer(
        builder: (_) {
          final supplier = controller.supplierModel;
          if (supplier == null) {
            return Text('Buscando dados do fornecedor');
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                title: ValueListenableBuilder<bool>(
                  valueListenable: sliverCollapsedVN,
                  builder: (_, sliverCollapsedValue, child) {
                    return Visibility(
                      visible: sliverCollapsedValue,
                      child: Text(
                        supplier.name,
                      ),
                    );
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: Image.network(
                    supplier.logo,
                    // 'https://super.abril.com.br/wp-content/uploads/2018/05/filhotes-de-cachorro-alcanc3a7am-o-c3a1pice-de-fofura-com-8-semanas1.png?quality=90&strip=info&resize=850,567',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SupplierDetail(
                  supplier: supplier,
                  controller: controller,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Serviços (${controller.totalServicesSelected} selecionado${controller.totalServicesSelected > 1 ? 's' : ''})',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: controller.supplierServices.length,
                  // childCount: controller.supplierServices.length,
                  (context, index) {
                    final service = controller.supplierServices[index];
                    return SupplierServiceWidget(
                      service: service,
                      supplierController: controller,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
