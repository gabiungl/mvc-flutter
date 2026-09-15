import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/patrimonio_controller.dart';
import '../models/patrimonio.dart';

class PatrimonioFormView extends StatefulWidget {
  const PatrimonioFormView({super.key, this.patrimonio});

  final Patrimonio? patrimonio;

  @override
  State<PatrimonioFormView> createState() => _PatrimonioFormViewState();
}

class _PatrimonioFormViewState extends State<PatrimonioFormView> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController inventarioController;
  late final TextEditingController descricaoController;
  late final TextEditingController localController;
  late final TextEditingController responsavelController;
  bool salvando = false;

  bool get editando => widget.patrimonio != null;

  @override
  void initState() {
    super.initState();
    final item = widget.patrimonio;
    inventarioController = TextEditingController(text: item?.numeroInventario);
    descricaoController = TextEditingController(text: item?.descricao);
    localController = TextEditingController(text: item?.local);
    responsavelController = TextEditingController(text: item?.responsavel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar patrimônio' : 'Novo patrimônio')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _campo(inventarioController, 'Número do inventário', Icons.tag),
            _campo(descricaoController, 'Descrição', Icons.description_outlined),
            _campo(localController, 'Local', Icons.location_on_outlined),
            _campo(responsavelController, 'Responsável', Icons.person_outline),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: salvando ? null : _salvar,
              icon: salvando
                  ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save_outlined),
              label: Text(salvando ? 'Salvando...' : 'Salvar patrimônio'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campo(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: (value) => value == null || value.trim().isEmpty ? 'Informe $label' : null,
      ),
    );
  }

  Future<void> _salvar() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => salvando = true);
    final item = Patrimonio(
      id: widget.patrimonio?.id,
      numeroInventario: inventarioController.text.trim(),
      descricao: descricaoController.text.trim(),
      local: localController.text.trim(),
      responsavel: responsavelController.text.trim(),
    );
    final sucesso = await Get.find<PatrimonioController>().salvar(
      id: widget.patrimonio?.id,
      patrimonio: item,
    );
    if (!mounted) return;
    setState(() => salvando = false);
    if (sucesso) {
      Get.back();
      Get.snackbar('Sucesso', editando ? 'Patrimônio atualizado.' : 'Patrimônio cadastrado.');
    }
  }

  @override
  void dispose() {
    inventarioController.dispose();
    descricaoController.dispose();
    localController.dispose();
    responsavelController.dispose();
    super.dispose();
  }
}
