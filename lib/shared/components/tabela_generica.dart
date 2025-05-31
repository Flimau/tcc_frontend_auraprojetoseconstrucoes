import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class TabelaGenerica extends StatelessWidget {
  final List<Map<String, dynamic>> dados;
  final List<String> colunas;
  final List<String> chaves;
  final Function(Map<String, dynamic>)? onEditar;
  final Function(int, bool)? onSort;
  final int? sortColumnIndex;
  final bool isAscending;

  const TabelaGenerica({
    super.key,
    required this.dados,
    required this.colunas,
    required this.chaves,
    this.onEditar,
    this.onSort,
    this.sortColumnIndex,
    this.isAscending = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => AppColors.primary.withOpacity(0.1),
        ),
        columns: [
          for (int i = 0; i < colunas.length; i++)
            DataColumn(
              label: Row(
                children: [
                  Text(colunas[i], style: AppTextStyles.headline),
                  if (i == 0 && sortColumnIndex == i) ...[
                    const SizedBox(width: 4),
                    Icon(
                      isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 16,
                      color: AppColors.accent,
                    ),
                  ],
                ],
              ),
              onSort:
                  (i == 0 && onSort != null)
                      ? (int columnIndex, bool ascending) =>
                          onSort!(columnIndex, ascending)
                      : null,
            ),
          if (onEditar != null)
            DataColumn(label: Text('Ações', style: AppTextStyles.headline)),
        ],
        rows: List<DataRow>.generate(dados.length, (index) {
          final dado = dados[index];
          final ehPar = index % 2 == 0;

          return DataRow(
            color: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              return ehPar ? AppColors.background : AppColors.white;
            }),
            cells: [
              ...chaves.map(
                (chave) => DataCell(
                  Text('${dado[chave]}', style: AppTextStyles.body),
                  onTap: () {
                    print('Célula $chave clicada com valor: ${dado[chave]}');
                  },
                ),
              ),
              if (onEditar != null)
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.accent),
                    onPressed: () => onEditar!(dado),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
