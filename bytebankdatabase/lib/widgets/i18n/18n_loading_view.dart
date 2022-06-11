import 'package:bytebankdatabase/http/webclients/i18n.dart';
import 'package:bytebankdatabase/widgets/container.dart';
import 'package:bytebankdatabase/widgets/giff_dialog.dart';
import 'package:bytebankdatabase/widgets/i18n/i18n_cubit.dart';
import 'package:bytebankdatabase/widgets/i18n/i18n_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';
import '../progress_indicator.dart';
import 'i18n_messages.dart';

// atingo => typedef Widget I18NWidgetCreator(I18NMessages messages);

typedef I18NWidgetCreator = Widget Function(I18NMessages messages);

class I18NLoadingView extends StatelessWidget {
  final I18NWidgetCreator _creator;
  I18NLoadingView(this._creator);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<I18NMessagesCubit, I18NMessagesState>(
      builder: ((context, state) {
        if (state is InitI18NMessagesState ||
            state is LoadingI18NMessagesState) {
          return ProgressoCustomizado();
        }

        if (state is LoadedI18NMessagesState) {
          final messages = state.messages;
          return _creator.call(messages);
        }

        return GifDialogComScaffold(
          message: 'Error',
        );
      }),
    );
  }
}
