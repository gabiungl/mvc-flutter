import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/patrimonio_controller.dart';
import '../models/patrimonio.dart';
import 'patrimonio_form_view.dart';

class DetalheView extends StatelessWidget {
  const DetalheView({super.key, required this.patrimonio});

  final Patrimonio patrimonio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do patrimônio'),
        actions: [
          IconButton(
            tooltip: 'Editar patrimônio',
            onPressed: () => Get.to(
              () => PatrimonioFormView(patrimonio: patrimonio),
            ),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Excluir patrimônio',
            onPressed: () => _confirmarExclusao(context),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.inventory_2, size: 72),
          const SizedBox(height: 20),
          _CampoDetalhe(rotulo: 'Número do inventário', valor: patrimonio.numeroInventario),
          _CampoDetalhe(rotulo: 'Descrição', valor: patrimonio.descricao),
          _CampoDetalhe(rotulo: 'Local', valor: patrimonio.local),
          _CampoDetalhe(rotulo: 'Responsável', valor: patrimonio.responsavel),
          _CampoDetalhe(rotulo: 'ID', valor: '${patrimonio.id ?? 'Não informado'}'),
        ],
      ),
    );
  }

  Future<void> _confirmarExclusao(BuildContext context) async {
    final confirmou = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Excluir patrimônio?'),
        content: const Text('Esta ação não poderá ser desfeita.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmou != true || !context.mounted) return;
    final sucesso = await Get.find<PatrimonioController>().excluir(patrimonio.id);
    if (sucesso) Get.back();
  }
}

class _CampoDetalhe extends StatelessWidget {
  const _CampoDetalhe({required this.rotulo, required this.valor});

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rotulo, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(valor.isEmpty ? 'Não informado' : valor, style: Theme.of(context).textTheme.bodyLarge),
          const Divider(),
        ],
      ),
    );
  }
}
