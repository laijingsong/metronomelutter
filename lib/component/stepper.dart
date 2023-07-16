import 'package:flutter/material.dart';

enum StepperEventType { increase, decrease }

typedef StepperChangeCallback(int val);

// - 3 +
class SyStepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;

  /// 步幅
  final int step;
  final double iconSize;
  final double textSize;
  final StepperChangeCallback onChange;
  final Function manualControl;

  const SyStepper({
    required Key key,
    this.value = 1,
    required this.onChange,
    this.min = 1,
    this.max = 9999999,
    this.step = 1,
    this.iconSize = 24.0,
    this.textSize = 24.0,
    required this.manualControl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int value = this.value;
    ThemeData theme = Theme.of(context);
    final iconPadding = const EdgeInsets.all(4.0);
    bool minusBtnDisabled = value <= this.min || value - this.step < this.min;
    bool addBtnDisabled = value >= this.max || value + this.step > this.max;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          child: Padding(
            padding: iconPadding,
            child: Icon(
              Icons.remove,
              size: this.iconSize,
              color: minusBtnDisabled ? theme.disabledColor : theme.textTheme.labelLarge?.color,
            ),
          ),
          onTap: minusBtnDisabled
              ? null
              : this.manualControl != null
                  ? () {
                      this.manualControl(
                        StepperEventType.decrease,
                        value,
                      );
                    }
                  : () {
                      int newVal = value - this.step;

                      this.onChange(newVal);
                    },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: ConstrainedBox(
            child: Center(
                child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: this.textSize,
                // color: Color.fromRGBO(84, 84, 84, 1),
              ),
            )),
            constraints: BoxConstraints(minWidth: this.iconSize),
          ),
        ),
        InkWell(
          child: Padding(
            padding: iconPadding,
            child: Icon(
              Icons.add,
              size: this.iconSize,
              color: addBtnDisabled ? theme.disabledColor : theme.textTheme.labelLarge?.color,
            ),
          ),
          onTap: addBtnDisabled
              ? null
              : this.manualControl != null
                  ? () {
                      this.manualControl(
                        StepperEventType.increase,
                        value,
                      );
                    }
                  : () {
                      int newVal = value + this.step;

                      this.onChange(newVal);
                    },
        ),
      ],
    );
  }
}
