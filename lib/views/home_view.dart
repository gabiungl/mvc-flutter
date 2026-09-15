import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/patrimonio_controller.dart';
import '../models/patrimonio.dart';
import 'detalhe_view.dart';
import 'patrimonio_form_view.dart';

class HomeView extends GetView<PatrimonioController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patrimônios SENAI'),
        actions: [
          IconButton(
            tooltip: 'Atualizar lista',
            onPressed: () => controller.carregar(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const PatrimonioFormView()),
        icon: const Icon(Icons.add),
        label: const Text('Novo patrimônio'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: controller.pesquisaController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => controller.carregar(pesquisa: value),
              decoration: InputDecoration(
                hintText: 'Pesquisar por inventário, descrição ou local',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  tooltip: 'Pesquisar',
                  onPressed: () => controller.carregar(
                    pesquisa: controller.pesquisaController.text,
                  ),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.carregando.value && controller.patrimonios.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.erro.value.isNotEmpty && controller.patrimonios.isEmpty) {
                return _MensagemErro(
                  mensagem: controller.erro.value,
                  tentarNovamente: () => controller.carregar(),
                );
              }
              if (controller.patrimonios.isEmpty) {
                return const Center(child: Text('Nenhum patrimônio encontrado.'));
              }
              return RefreshIndicator(
                onRefresh: () => controller.carregar(),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: controller.patrimonios.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, index) => _PatrimonioCard(controller.patrimonios[index]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _PatrimonioCard extends StatelessWidget {
  const _PatrimonioCard(this.patrimonio);

  final Patrimonio patrimonio;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.inventory_2_outlined),
        ),
        title: Text(
          patrimonio.descricao.isEmpty ? 'Sem descrição' : patrimonio.descricao,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Inventário: ${patrimonio.numeroInventario}\n'
          'Local: ${patrimonio.local}\n'
          'Responsável: ${patrimonio.responsavel}',
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (patrimonio.id == null || patrimonio.id.toString().trim().isEmpty) {
            Get.snackbar('Patrimônio inválido', 'Este item não possui identificador válido.');
            return;
          }
          Get.to(() => DetalheView(patrimonio: patrimonio));
        },
      ),
    );
  }
}

class _MensagemErro extends StatelessWidget {
  const _MensagemErro({required this.mensagem, required this.tentarNovamente});

  final String mensagem;
  final VoidCallback tentarNovamente;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            Text(mensagem, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: tentarNovamente,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
