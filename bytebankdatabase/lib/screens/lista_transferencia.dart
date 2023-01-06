import 'package:bytebankdatabase/http/webclients/transferencia_webclient.dart';
import 'package:bytebankdatabase/model/transferencia.dart';
import 'package:bytebankdatabase/widgets/centered_message.dart';
import 'package:bytebankdatabase/widgets/contact_list_dialog.dart';
import 'package:bytebankdatabase/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class ListaTransferencias extends StatefulWidget {
  @override
  State<ListaTransferencias> createState() => _ListaTransferenciasState();
}

class _ListaTransferenciasState extends State<ListaTransferencias> {
  final TransferenciaWebClient transferenciaWebCliente =
      TransferenciaWebClient();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transferencias"),
      ),
      body: FutureBuilder<List<Transferencia>>(
          future: transferenciaWebCliente.findAll(),
          builder: (context, snapshot) {
            final List<Transferencia> _transferencias = snapshot.data ?? [];
            if (snapshot.hasError) {
              return CenteredMessage(
                'Erro na requisicao',
                icon: Icons.warning,
              );
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return ProgressoCustomizado(
                  mensagemDoIndicator: 'Aguarde...',
                );
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (_transferencias.isNotEmpty) {
                  return ListView.builder(
                    itemCount: _transferencias.length,
                    itemBuilder: (context, indice) {
                      final transferencia = _transferencias[indice];
                      return ItemTransferencia(transferencia);
                    },
                  );
                } else {
                  return CenteredMessage(
                    'Nao foi encontrado transferencias',
                    icon: Icons.warning,
                  );
                }
            }
            return CenteredMessage(
              'Erro desconhecido',
              icon: Icons.error,
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (contextDialog) {
                return ContactsDialog();
              }).whenComplete(() => setState(() {}));
        },
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  Transferencia? _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.monetization_on_outlined,
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_transferencia!.contato!.name.toString()),
            Text(', conta: '),
            Text(_transferencia!.contato!.accountNumber.toString()),
          ],
        ),
        subtitle: Text('Valor: ${_transferencia!.valor.toString()}'),
      ),
    );
  }
}
