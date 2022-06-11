import 'package:bytebankdatabase/widgets/i18n/i18n_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../http/webclients/i18n.dart';
import '../container.dart';
import '18n_loading_view.dart';

class I18NLoadingContainer extends BlocContainer {
  final I18NWidgetCreator creator;
  final String viewKey;

  I18NLoadingContainer({required this.viewKey, required this.creator});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessagesCubit>(
      create: ((BuildContext context) {
        final cubit = I18NMessagesCubit(viewKey);
        cubit.reload(I18NWebClient(viewKey));
        return cubit;
      }),
      child: I18NLoadingView(creator),
    );
  }
}
