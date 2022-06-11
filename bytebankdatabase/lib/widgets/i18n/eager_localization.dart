import 'package:bytebankdatabase/widgets/i18n/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewI18N {
  late String _language;
  //O problema dessa abordagem é o rebuild quando vc troca a lingua
  //Pense no que vc quer recostruir quando trocar o CurrentLocaleCubit.
  //Em geral, é comum reiniciar o app inteiro. Ou voltar para tela anterior.
  ViewI18N(BuildContext context) {
    _language = BlocProvider.of<CurrentLocaleCubit>(context).state;
  }

  //opcao Caso eu queria trabalhar passando map
  //String localiza(Map<String, String> values) {
  //  assert(values != null);
  //  assert(values.containsKey(_language));
  //
  //  return values[_language]!;
  //}

  String locale() {
    return _language;
  }
}
