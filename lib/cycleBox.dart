import 'package:flutter/material.dart';

import './global.dart';
import './deleteDialog.dart';
// import './cycleHome.dart';

class CycleBox extends StatelessWidget {
  final String cycleName;
  final int cycleKey;
  final Function deleteCycle;

  CycleBox(this.cycleName, this.cycleKey, this.deleteCycle);

  void delete() {
    deleteCycle(cycleKey);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        // onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => CycleHome(
        //         cycleName: cycleName,
        //       ),
        //     ),
        //   );
        // },
        onLongPress: () => showDialog(
            context: context,
            builder: (_) {
              return DeleteDialog(
                name: cycleName,
                deleteFunction: delete,
              );
            }),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Color(0xFF484850),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Text(
            this.cycleName,
            style: programBoxTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// class CycleData {

// }
