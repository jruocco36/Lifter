import 'package:flutter/material.dart';

import './cycleBox.dart';

class CycleList extends StatelessWidget {
  final Map<int, String> cycles;
  final Function deleteCycle;

  CycleList({
    @required this.cycles,
    @required this.deleteCycle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        children: [
          ...(cycles.keys).map((cycle) {
            return CycleBox(cycles[cycle], cycle, deleteCycle);
          }).toList()
        ],
      ),
    );
  }
}
