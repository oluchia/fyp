import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class MyProgressIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //print(Offset(0.0, -1.0).distanceSquared - Offset(0.0, 0.0).distanceSquared);

    return new Stack(
      children: <Widget>[
        new Opacity(
          opacity: 0.3,
          child: const ModalBarrier(
            dismissible: false,
            color: Colors.grey,
          )),
          new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                JumpingDotsProgressIndicator(
                  fontSize: 60.0,
                  color: Colors.blue,
                ),
                SizedBox(height: 60.0)
              ],
            )
          )
      ],
    );
  }
}