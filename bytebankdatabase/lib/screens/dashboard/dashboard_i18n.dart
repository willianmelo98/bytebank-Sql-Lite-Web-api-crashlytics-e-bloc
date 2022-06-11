import '../../widgets/i18n/i18n_messages.dart';

class DashboardViewLazyI18N {
  final I18NMessages? messages;
  DashboardViewLazyI18N({this.messages});
  String get transfer => messages!.get('transfer');

  String get transfers => messages!.get('listTransfers');

  String get changeName => messages!.get('ChangeName');
}

//Outra forma   :
//class DashboardViewI18N extends ViewI18N {
//  DashboardViewI18N(BuildContext context) : super(context);
//  String get transfer => localiza({'pt-br': 'transferencia', 'en': 'transfer'});
//
//  String get transfers =>
//      localiza({'pt-br': 'transferencias', 'en': 'list of transfer'});
//
//  String get changeName =>
//      localiza({'pt-br': 'Alterar Nome', 'en': 'Change Name'});
//}
