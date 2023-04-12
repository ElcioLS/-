import 'package:adf_cuidapet/app/modules/schedules/schedules_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SchedulesModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (context, args) => const SchedulesPage(),
    ),
  ];
}
