import 'package:bytebankdatabase/widgets/tema_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountCubit extends Cubit<int> {
  CountCubit() : super(0);
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

class CountContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (contextBloc) => CountCubit(),
      child: CountView(),
    );
  }
}

class CountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final temaTexto = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo count'),
      ),
      body: Center(
        child: BlocBuilder<CountCubit, int>(
          builder: (context, state) {
            return Text(
              '$state',
              style: temaTexto.headline2,
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<CountCubit>().increment();
            },
            child: Icon(Icons.add),
          ),
          const SizedBox(
            height: 8,
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<CountCubit>().decrement();
            },
            child: Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}
