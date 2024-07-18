import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test setState logic', (WidgetTester tester) async {
    int _modeNow = 1;
    int _completedCycles = 3;
    int _cyclesUntilLongBreak = 4;

    await tester.pumpWidget(MaterialApp(
      home: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          setState(() {
            if (_modeNow == 1) _completedCycles++;
            _completedCycles == _cyclesUntilLongBreak
                ? (_modeNow = 3, _completedCycles = 1)
                : (_modeNow == 1 ? _modeNow = 2 : _modeNow = 1);
          });

          return Container();
        },
      ),
    ));
    expect(_modeNow, 3);
    expect(_completedCycles, 1);
  });
}
