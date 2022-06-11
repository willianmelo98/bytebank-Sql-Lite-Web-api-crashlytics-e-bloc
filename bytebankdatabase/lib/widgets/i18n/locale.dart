import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../container.dart';

class LocalizationContainer extends BlocContainer {
  final Widget widget;
  LocalizationContainer({
    required this.widget,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrentLocaleCubit>(
      create: (context) => CurrentLocaleCubit(),
      child: widget,
    );
  }
}

class CurrentLocaleCubit extends Cubit<String> {
  CurrentLocaleCubit() : super('pt-br');
}
