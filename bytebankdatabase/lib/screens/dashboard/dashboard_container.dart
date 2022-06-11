import 'package:bytebankdatabase/model/name.dart';
import 'package:bytebankdatabase/screens/dashboard/dashboard_view.dart';
import 'package:bytebankdatabase/widgets/i18n/i18n_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_i18n.dart';

class DashboardContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (contextBloc) => NameCubit('Willian'),
      child: I18NLoadingContainer(
        viewKey: "dashboard",
        creator: ((messages) => DashboardView(
              DashboardViewLazyI18N(messages: messages),
            )),
      ),
    );
  }
}
