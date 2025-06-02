import 'package:flutter/material.dart';

import '../../../shared/components/form_widgets.dart';
import '../../../shared/services/obra_service.dart'; // IMPORT do ObraService
import '../models/obra.dart';

class ObraListController extends ChangeNotifier {
  // Controllers para os campos de busca
  final valorBuscaController = TextEditingController();
  final dataInicioController = TextEditingController();
  final dataFimController = TextEditingController();

  String chaveSelecionada = 'ID';

  final List<String> chaves = [
    'ID',
    'Nome da Obra',
    'Cliente',
    'Status',
    'Data de criação',
  ];

  // Lista de resultados (vazia até carregarmos do back)
  List<Obra> resultados = [];

  bool carregando = false;
  String? erro; // guarda mensagem de erro, se houver

  /// Construtor opcional que já dispara a busca inicial de todas as obras
  ObraListController() {
    buscarTodasObras(); // Carrega todas assim que o controller for criado
  }

  void atualizarChave(String novaChave) {
    chaveSelecionada = novaChave;
    notifyListeners();
  }

  /// Busca todas as obras sem nenhum filtro
  Future<void> buscarTodasObras() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      List<Obra> lista = await ObraService.fetchAllObras();
      resultados = lista;
    } catch (e) {
      erro = 'Erro ao carregar obras: $e';
      resultados = [];
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  /// Executa a busca de acordo com o critério selecionado
  Future<void> buscar(BuildContext context) async {
    final valor = valorBuscaController.text.trim();
    final dataInicioText = dataInicioController.text.trim();
    final dataFimText = dataFimController.text.trim();

    // Se pesquisar por intervalo de datas ("Data de criação")
    if (chaveSelecionada == 'Data de criação') {
      // Valida se ambos estão preenchidos
      if (dataInicioText.isEmpty || dataFimText.isEmpty) {
        mostrarMensagem(
          context,
          'Preencha ambas as datas para buscar por intervalo',
          erro: true,
        );
        return;
      }

      final hoje = DateTime.now();
      final dataInicioParsed = _parseData(dataInicioText);
      final dataFimParsed = _parseData(dataFimText);
      if (dataInicioParsed == null || dataFimParsed == null) {
        mostrarMensagem(
          context,
          'Formato de data inválido (use DD/MM/AAAA)',
          erro: true,
        );
        return;
      }
      if (dataFimParsed.isAfter(hoje)) {
        mostrarMensagem(
          context,
          'Data final não pode ser maior que hoje',
          erro: true,
        );
        return;
      }
      if (dataFimParsed.isBefore(dataInicioParsed)) {
        mostrarMensagem(
          context,
          'Data final não pode ser anterior à data inicial',
          erro: true,
        );
        return;
      }

      // Converte para formato ISO (YYYY-MM-DD) exigido pelo back
      final isoInicio = _toIsoDate(dataInicioParsed);
      final isoFim = _toIsoDate(dataFimParsed);

      carregando = true;
      erro = null;
      notifyListeners();

      try {
        List<Obra> lista = await ObraService.fetchByPeriod(isoInicio, isoFim);
        resultados = lista;
      } catch (e) {
        erro = 'Erro ao buscar por período: $e';
        resultados = [];
      } finally {
        carregando = false;
        notifyListeners();
      }

      return;
    }

    // Se o campo de texto estiver vazio E não é busca por data, então carrega tudo
    if (valor.isEmpty) {
      mostrarMensagem(context, 'Buscando todas as obras...');
      await buscarTodasObras();
      return;
    }

    // A partir daqui, temos um "valor" não vazio e não estamos filtrando por data
    switch (chaveSelecionada) {
      case 'ID':
        await _buscarPorId(context, valor);
        break;

      case 'Nome da Obra':
        await _buscarPorNome(valor);
        break;

      case 'Cliente':
        await _buscarPorCliente(valor);
        break;

      case 'Status':
        await _buscarPorStatus(valor);
        break;

      default:
        // se cair aqui, pega tudo
        await buscarTodasObras();
        break;
    }
  }

  /// Busca uma única Obra pelo ID exato via endpoint GET /api/obras/{id}
  Future<void> _buscarPorId(BuildContext context, String valor) async {
    final idNum = int.tryParse(valor);
    if (idNum == null) {
      mostrarMensagem(context, 'ID inválido', erro: true);
      return;
    }

    carregando = true;
    erro = null;
    resultados = [];
    notifyListeners();

    try {
      Obra obra = await ObraService.fetchObraById(valor);
      resultados = [obra];
    } catch (e) {
      // Se não encontrar, o back pode retornar 404. Mostramos mensagem:
      erro = 'Nenhuma obra encontrada para ID $valor';
      resultados = [];
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  /// Busca por "Nome da Obra" filtrando localmente após GET /api/obras
  Future<void> _buscarPorNome(String valor) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      // Pega todas e filtra no Dart; o back não tem endpoint de nome
      List<Obra> lista = await ObraService.fetchAllObras();
      resultados =
          lista.where((obra) {
            // Aqui assumimos que "nome da obra" é igual a clienteNome,
            // ou você pode ajustar se tiver um campo distinto para nome da obra
            return obra.clienteNome.toLowerCase().contains(valor.toLowerCase());
          }).toList();
    } catch (e) {
      erro = 'Erro ao filtrar por nome: $e';
      resultados = [];
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  /// Busca por "Cliente", filtrando localmente
  Future<void> _buscarPorCliente(String valor) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      List<Obra> lista = await ObraService.fetchAllObras();
      resultados =
          lista.where((obra) {
            return obra.clienteNome.toLowerCase().contains(valor.toLowerCase());
          }).toList();
    } catch (e) {
      erro = 'Erro ao filtrar por cliente: $e';
      resultados = [];
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  /// Busca por "Status", filtrando localmente
  Future<void> _buscarPorStatus(String valor) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      List<Obra> lista = await ObraService.fetchAllObras();
      resultados =
          lista.where((obra) {
            return obra.status.toLowerCase().contains(valor.toLowerCase());
          }).toList();
    } catch (e) {
      erro = 'Erro ao filtrar por status: $e';
      resultados = [];
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  /// Converte string “DD/MM/AAAA” para DateTime ou retorna null se inválida
  DateTime? _parseData(String data) {
    try {
      final partes = data.split('/');
      return DateTime(
        int.parse(partes[2]),
        int.parse(partes[1]),
        int.parse(partes[0]),
      );
    } catch (_) {
      return null;
    }
  }

  /// Converte DateTime para “YYYY-MM-DD”
  String _toIsoDate(DateTime d) {
    final ano = d.year.toString().padLeft(4, '0');
    final mes = d.month.toString().padLeft(2, '0');
    final dia = d.day.toString().padLeft(2, '0');
    return '$ano-$mes-$dia';
  }
}
