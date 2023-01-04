import 'package:flutter/material.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/features/home.dart';
import 'package:save_my_food/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NormalLayout(
      title: 'Settings',
      children: [
        const ToggleSetting(text: 'Remove expired products'),
        const SizedBox(height: 35),
        const ToggleSetting(text: 'Turn on notifications'),
        const SizedBox(height: 35),
        SliderSetting(
          text: 'Send notifications every',
          labeling: (days) => '$days days',
          labelOffset: const Offset(-10, 0),
          divisions: 10,
        ),
        const SizedBox(height: 20),
        SliderSetting(
          text: 'Preferred notification time',
          labeling: (hours) => '${hours < 10 ? '0' : ''}$hours:00',
          labelOffset: const Offset(-7, 0),
          divisions: 24,
        ),
      ],
    );
  }
}

class SliderSetting extends StatefulWidget {
  final String text;
  final double initialValue;
  final double divisions;
  final Offset labelOffset;
  final String Function(int) labeling;

  const SliderSetting({
    Key? key,
    required this.text,
    required this.labeling,
    required this.divisions,
    this.labelOffset = Offset.zero,
    this.initialValue = 0,
  }) : super(key: key);

  @override
  State<SliderSetting> createState() => _SliderSettingState();
}

class _SliderSettingState extends State<SliderSetting> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double divisionOffset = (width - 80) / widget.divisions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(widget.text),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: SliderTheme(
            data: SliderThemeData(
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: _value,
              max: widget.divisions,
              divisions: widget.divisions.round(),
              inactiveColor: HexColor.lightGray.get(),
              onChanged: (value) => setState(() => _value = value),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Transform.translate(
          offset: widget.labelOffset,
          child: AnimatedPadding(
            padding: EdgeInsets.only(left: divisionOffset * _value),
            duration: const Duration(milliseconds: 100),
            child: NormalText(widget.labeling(_value.round()), size: 12),
          ),
        ),
      ],
    );
  }
}

class ToggleSetting extends StatefulWidget {
  final String text;
  final bool isInitiallyOn;

  const ToggleSetting({
    Key? key,
    required this.text,
    this.isInitiallyOn = false,
  }) : super(key: key);

  @override
  State<ToggleSetting> createState() => _ToggleSettingState();
}

class _ToggleSettingState extends State<ToggleSetting> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.isInitiallyOn;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NormalText(widget.text),
        const Spacer(),
        InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () => setState(() => _isOn = !_isOn),
          child: Container(
            width: 50,
            height: 25,
            decoration: BoxDecoration(
              color: _isOn ? HexColor.pink.get() : HexColor.lightGray.get(),
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(_isOn ? 10 : -10, 0),
              child: Container(
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 30),
      ],
    );
  }
}
