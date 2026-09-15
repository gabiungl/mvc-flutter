import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/patrimonio.dart';
import '../services/api_service.dart';

class PatrimonioController extends GetxController {
  PatrimonioController(this.apiService);

  final ApiService apiService;
  final patrimonios = <Patrimonio>[].obs;
  final carregando = false.obs;
  final erro = ''.obs;
  final pesquisaController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    carregar();
  }

  Future<void> carregar({String? pesquisa}) async {
    carregando.value = true;
    erro.value = '';
    try {
      patrimonios.assignAll(await apiService.listar(pesquisa: pesquisa));
    } catch (exception) {
      erro.value = _mensagem(exception);
    } finally {
      carregando.value = false;
    }
  }

  Future<Patrimonio?> buscar(dynamic id) async {
    try {
      return await apiService.buscarPorId(id);
    } catch (exception) {
      _mostrarErro(exception);
      return null;
    }
  }

  Future<bool> salvar({dynamic id, required Patrimonio patrimonio}) async {
    try {
      if (id == null) {
        await apiService.criar(patrimonio);
      } else {
        await apiService.atualizar(id, patrimonio);
      }
      await carregar(pesquisa: pesquisaController.text);
      return true;
    } catch (exception) {
      _mostrarErro(exception);
      return false;
    }
  }

  Future<bool> excluir(dynamic id) async {
    try {
      await apiService.excluir(id);
      await carregar(pesquisa: pesquisaController.text);
      return true;
    } catch (exception) {
      _mostrarErro(exception);
      return false;
    }
  }

  void _mostrarErro(Object exception) {
    Get.snackbar('Não foi possível concluir', _mensagem(exception));
  }

  String _mensagem(Object exception) => exception.toString().replaceFirst('Exception: ', '');

  @override
  void onClose() {
    pesquisaController.dispose();
    super.onClose();
  }
}
