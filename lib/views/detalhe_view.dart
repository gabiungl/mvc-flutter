import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/patrimonio_controller.dart';
import '../models/patrimonio.dart';
import 'patrimonio_form_view.dart';

class DetalheView extends StatefulWidget {
  const DetalheView({super.key, required this.patrimonio});

  final Patrimonio patrimonio;

  @override
  State<DetalheView> createState() => _DetalheViewState();
}

class _DetalheViewState extends State<DetalheView> {
  late Patrimonio _patrimonio;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _patrimonio = widget.patrimonio;
    _carregarDetalhe();
  }

  Future<void> _carregarDetalhe() async {
    final controller = Get.find<PatrimonioController>();
    final item = await controller.buscar(_patrimonio.id);
    if (!mounted) return;

    setState(() {
      _carregando = false;
      if (item != null) {
        _patrimonio = item;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PatrimonioController>();
    final id = _patrimonio.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do patrimônio'),
        actions: [
          IconButton(
            tooltip: 'Editar patrimônio',
            onPressed: () => Get.to(() => PatrimonioFormView(patrimonio: _patrimonio)),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Excluir patrimônio',
            onPressed: () => _confirmarExclusao(context, id),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.carregandoDetalhe.value || _carregando) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.erroDetalhe.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 12),
                  Text(controller.erroDetalhe.value, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _carregarDetalhe,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.inventory_2, size: 72),
            const SizedBox(height: 20),
            _CampoDetalhe(rotulo: 'Número do inventário', valor: _patrimonio.numeroInventario),
            _CampoDetalhe(rotulo: 'Descrição', valor: _patrimonio.descricao),
            _CampoDetalhe(rotulo: 'Local', valor: _patrimonio.local),
            _CampoDetalhe(rotulo: 'Responsável', valor: _patrimonio.responsavel),
            _CampoDetalhe(rotulo: 'ID', valor: '${_patrimonio.id ?? 'Não informado'}'),
          ],
        );
      }),
    );
  }

  Future<void> _confirmarExclusao(BuildContext context, dynamic id) async {
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
    final sucesso = await Get.find<PatrimonioController>().excluir(id);
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
