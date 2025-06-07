import 'package:flutter/material.dart';
import 'package:front_application/theme/theme.dart';

/// Widget genérico para buscas com:
///  - Dropdown de chaves (strings) passadas em `keys`.
///  - Campo de texto (sempre exibido, a não ser que a chave seja de intervalo de datas).
///  - Dois campos de data (início e fim) exibidos apenas se `chaveSelecionada` fizer parte de `keysComIntervalo`.
///  - Botão “Buscar” que dispara `onBuscar`.
///
/// Exemplo de uso:
/// ```dart
/// InputCampoBusca(
///   keys: ['ID', 'Cliente', 'Status', 'Data'],
///   keysComIntervalo: {'Data'},
///   chaveSelecionada: meuController.chaveSelecionada,
///   onChaveChanged: (novaChave) => meuController.atualizarChave(novaChave),
///   valorController: meuController.valorBuscaController,
///   dataInicioController: meuController.dataInicioController,
///   dataFimController: meuController.dataFimController,
///   onBuscar: () => meuController.buscar(context),
/// ),
/// ```
///
/// Parâmetros:
///  - `keys`: lista de strings para popular o dropdown.
///  - `keysComIntervalo`: conjunto de chaves que indicam “busca por intervalo de datas”.
///  - `chaveSelecionada`: chave atualmente selecionada no dropdown.
///  - `onChaveChanged`: callback (String) executado quando o usuário escolher outra chave.
///  - `valorController`: TextEditingController para o campo de texto livre.
///  - `dataInicioController` e `dataFimController`: TextEditingController para data de início e fim.
///  - `onBuscar`: callback (void) acionado ao clicar em “Buscar”.
class InputCampoBusca extends StatelessWidget {
  final List<String> keys;
  final Set<String> keysComIntervalo;
  final String chaveSelecionada;
  final ValueChanged<String> onChaveChanged;
  final TextEditingController valorController;
  final TextEditingController dataInicioController;
  final TextEditingController dataFimController;
  final VoidCallback onBuscar;

  const InputCampoBusca({
    Key? key,
    required this.keys,
    required this.keysComIntervalo,
    required this.chaveSelecionada,
    required this.onChaveChanged,
    required this.valorController,
    required this.dataInicioController,
    required this.dataFimController,
    required this.onBuscar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIntervalo = keysComIntervalo.contains(chaveSelecionada);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // 1) Dropdown de chaves
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                value: chaveSelecionada,
                items:
                    keys
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c, style: AppTextStyles.body),
                          ),
                        )
                        .toList(),
                onChanged: (novo) {
                  if (novo != null) onChaveChanged(novo);
                },
                decoration: InputDecoration(
                  labelText: 'Filtrar por',
                  labelStyle: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 2) Se a chave atual for “busca por intervalo de datas”, mostramos dois campos de data:
            if (isIntervalo) ...[
              Expanded(
                flex: 3,
                child: TextField(
                  controller: dataInicioController,
                  keyboardType: TextInputType.datetime,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    labelText: 'Início (DD/MM/AAAA)',
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: AppColors.accent,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintStyle: AppTextStyles.subtitle,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: dataFimController,
                  keyboardType: TextInputType.datetime,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    labelText: 'Fim (DD/MM/AAAA)',
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: AppColors.accent,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintStyle: AppTextStyles.subtitle,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ] else ...[
              // 3) Caso contrário, exibimos um único campo de texto
              Expanded(
                flex: 5,
                child: TextField(
                  controller: valorController,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    labelText: 'Valor',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.accent,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintStyle: AppTextStyles.subtitle,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(width: 12),

            // 4) Botão Buscar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: AppTextStyles.fontButton.copyWith(
                  color: AppColors.white,
                ),
              ),
              onPressed: onBuscar,
              child: const Text('Buscar'),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
