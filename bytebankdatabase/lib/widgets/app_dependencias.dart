import 'package:bytebankdatabase/database/dao/contact_dao.dart';
import 'package:bytebankdatabase/http/webclients/transferencia_webclient.dart';
import 'package:flutter/material.dart';

class AppDependencias extends InheritedWidget {
  final ContactDao contactDao;
  final TransferenciaWebClient transferenciaWebCliente;
  final Widget child;
  AppDependencias(
      {required this.contactDao,
      required this.transferenciaWebCliente,
      required this.child})
      : super(child: child);

  static AppDependencias of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppDependencias>()!;
  }

  @override
  bool updateShouldNotify(AppDependencias oldWidget) {
    return contactDao != oldWidget.contactDao ||
        transferenciaWebCliente != oldWidget.transferenciaWebCliente;
  }
}
