import 'package:bytebankdatabase/model/name.dart';
import 'package:bytebankdatabase/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return NameView();
  }
}

class NameView extends StatelessWidget {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = context.read<NameCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apelido exemplo'),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Apelido'),
            style: const TextStyle(fontSize: 24.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  context.read<NameCubit>().change(nameController.text);
                  Navigator.pop(context);
                },
                child: const Text('Alterar'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
