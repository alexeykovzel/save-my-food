import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/features/home.dart';
import 'package:save_my_food/theme.dart';

import 'settings.dart';

class SettingsViewPage extends StatelessWidget {
  const SettingsViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) => NormalLayout(
        title: 'Settings',
        content: Column(
          children: [
            ToggleSetting(
              text: 'Remove expired products',
              onChanged: (isOn) => settings.deleteExpired = isOn,
              isOn: settings.deleteExpired,
            ),
            const SizedBox(height: 35),
            ToggleSetting(
              text: 'Turn on notifications',
              onChanged: (isOn) => settings.notifyUser = isOn,
              isOn: settings.notifyUser,
            ),
            const SizedBox(height: 35),
            SliderSetting(
              text: 'Send notifications every',
              labelOffset: const Offset(-10, 0),
              labeling: (days) => '$days days',
              onChanged: (days) => settings.notifyAfterDays = days + 1,
              initialValue: settings.notifyAfterDays.toDouble(),
              divisions: 11,
              offset: 1,
            ),
            const SizedBox(height: 20),
            SliderSetting(
              text: 'Preferred notification hour',
              labelOffset: const Offset(-7, 0),
              labeling: (hours) => settings.notifyAt,
              onChanged: (hours) => settings.notifyAtHour = hours,
              initialValue: settings.notifyAtHour.toDouble(),
              divisions: 23,
            ),
            const SizedBox(height: 20),
            SliderSetting(
              text: 'Preferred notification minute',
              labelOffset: const Offset(-7, 0),
              labeling: (minutes) => settings.notifyAt,
              onChanged: (minutes) => settings.notifyAtMinute = minutes,
              initialValue: settings.notifyAtMinute.toDouble(),
              divisions: 60,
            ),
          ],
        ),
      ),
    );
  }
}

class SliderSetting extends StatefulWidget {
  final String text;
  final double initialValue;
  final double divisions;
  final double offset;
  final Offset labelOffset;
  final String Function(int) labeling;
  final Function(int) onChanged;

  const SliderSetting({
    Key? key,
    required this.text,
    required this.labeling,
    required this.divisions,
    required this.onChanged,
    this.offset = 0,
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
    double width = MediaQuery.of(context).size.width;
    double divisionOffset = (width - 80) / widget.divisions;
    double labelOffset = divisionOffset * (_value - widget.offset);
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
              min: widget.offset,
              max: widget.divisions + widget.offset,
              divisions: widget.divisions.round(),
              inactiveColor: HexColor.lightGray.get(),
              onChanged: (value) {
                setState(() => _value = value);
                widget.onChanged(_value.round());
              },
            ),
          ),
        ),
        const SizedBox(height: 6),
        Transform.translate(
          offset: widget.labelOffset,
          child: AnimatedPadding(
            padding: EdgeInsets.only(left: labelOffset),
            duration: const Duration(milliseconds: 90),
            child: NormalText(widget.labeling(_value.round()), size: 12),
          ),
        ),
      ],
    );
  }
}

class ToggleSetting extends StatefulWidget {
  final Function(bool) onChanged;
  final String text;
  final bool isOn;

  const ToggleSetting({
    Key? key,
    required this.onChanged,
    required this.text,
    this.isOn = false,
  }) : super(key: key);

  @override
  State<ToggleSetting> createState() => _ToggleSettingState();
}

class _ToggleSettingState extends State<ToggleSetting> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NormalText(widget.text),
        const Spacer(),
        InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            setState(() => _isOn = !_isOn);
            widget.onChanged(_isOn);
          },
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
