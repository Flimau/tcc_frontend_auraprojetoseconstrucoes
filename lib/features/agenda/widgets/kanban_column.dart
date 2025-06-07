// lib/features/kanban/widgets/kanban_column.dart

import 'package:flutter/material.dart';

import '../models/kanban_card.dart';

class KanbanColumn extends StatelessWidget {
  final String titulo;
  final List<KanbanCard> cards;
  final Function(KanbanCard) onDragStarted;
  final Function(KanbanCard) onAccept;

  const KanbanColumn({
    super.key,
    required this.titulo,
    required this.cards,
    required this.onDragStarted,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DragTarget<KanbanCard>(
        onWillAccept: (data) => data != null,
        onAccept: (data) => onAccept(data),
        builder: (context, candidate, rejected) {
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children:
                        cards.map((card) {
                          return Draggable<KanbanCard>(
                            data: card,
                            feedback: Material(
                              child: Container(
                                width: 200,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(card.titulo),
                              ),
                            ),
                            child: Card(
                              child: ListTile(
                                title: Text(card.titulo),
                                subtitle: Text(card.descricao),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
