import 'package:bytebankdatabase/widgets/i18n/i18n_messages.dart';
import 'package:bytebankdatabase/widgets/i18n/i18n_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

import '../../http/webclients/i18n.dart';

class I18NMessagesCubit extends Cubit<I18NMessagesState> {
  final storage = LocalStorage('jsonGit.json');
  final String _viewKey;
  I18NMessagesCubit(this._viewKey) : super(const InitI18NMessagesState());

  reload(I18NWebClient client) async {
    emit(LoadingI18NMessagesState());
    // final items = await getStoraItem();
    // if (items != null) {
    //   emit(LoadedI18NMessagesState(I18NMessages(items)));
    //   return;
    // }
    client.findAll().then(saveAndRefresh);
  }

  Future<dynamic> getStoraItem() async {
    await storage.ready.catchError((e) => print(e));
    final items = storage.getItem(_viewKey);
    return items;
  }

  saveAndRefresh(Map<String, dynamic> messages) {
    storage.setItem(_viewKey, messages);
    emit(LoadedI18NMessagesState(I18NMessages(messages)));
  }
}
