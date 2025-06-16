import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'acompanhamento_dtos.dart';
import 'provider.dart';
import 'tela_cadastro_dia.dart';

class TelaAcompanhamentoObra extends StatefulWidget {
  final int obraId;

  const TelaAcompanhamentoObra({super.key, required this.obraId});

  @override
  State<TelaAcompanhamentoObra> createState() => _TelaAcompanhamentoObraState();
}

class _TelaAcompanhamentoObraState extends State<TelaAcompanhamentoObra> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AcompanhamentoProvider>(
        context,
        listen: false,
      ).carregarPorObra(widget.obraId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final acompanhamento =
        context.watch<AcompanhamentoProvider>().acompanhamentos;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Acompanhamento de Obra",
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF3B2626),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final registro = acompanhamento.firstWhere(
                  (e) =>
                      e.dataRegistro.year == day.year &&
                      e.dataRegistro.month == day.month &&
                      e.dataRegistro.day == day.day,
                  orElse:
                      () => AcompanhamentoListagemDTO(
                        id: 0,
                        dataRegistro: day,
                        status: StatusAcompanhamento.VAZIO,
                      ),
                );
                if (registro.id != 0) {
                  Color corDia;

                  switch (registro.status) {
                    case StatusAcompanhamento.CONCLUIDO:
                      corDia = const Color(0xFF228B22); // verde
                      break;
                    case StatusAcompanhamento.PREVISTO:
                      corDia = const Color(0xFFD4AF37); // dourado
                      break;
                    case StatusAcompanhamento.ATRASADO:
                      corDia = const Color(0xFFB22222); // vermelho
                      break;
                    default:
                      corDia = Colors.transparent;
                  }

                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: corDia,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "${day.day}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => TelaCadastroDia(
                        obraId: widget.obraId,
                        dataRegistro: selected,
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
