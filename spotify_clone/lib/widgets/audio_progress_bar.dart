import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';

class AudioProgressBar extends StatefulWidget {
  final bool isMini;

  const AudioProgressBar({
    Key? key,
    this.isMini = false,
  }) : super(key: key);

  @override
  State<AudioProgressBar> createState() => _AudioProgressBarState();
}

class _AudioProgressBarState extends State<AudioProgressBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    // Chỉ đọc provider một lần
    final audioProvider = context.read<AudioProvider>();

    return StreamBuilder<Duration>(
      stream: audioProvider.positionStream,
      builder: (context, snapshot) {
        // Vị trí hiện tại (milliseconds)
        final double currentPosition =
            (snapshot.data ?? Duration.zero).inMilliseconds.toDouble();

        // Tổng thời lượng
        final double maxDuration =
            audioProvider.duration.inMilliseconds.toDouble();

        final double safeMax = maxDuration > 0 ? maxDuration : 1.0;

        final double value =
            (_dragValue ?? currentPosition).clamp(0.0, safeMax);

        return SliderTheme(
          data: SliderThemeData(
            trackHeight: widget.isMini ? 2 : 4,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: widget.isMini ? 4 : 6,
            ),
            overlayShape: widget.isMini
                ? SliderComponentShape.noOverlay
                : const RoundSliderOverlayShape(
                    overlayRadius: 14,
                  ),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
            thumbColor: Colors.white,
          ),
          child: Slider(
            min: 0.0,
            max: safeMax,
            value: value,

            onChangeStart: (_) {
              setState(() {
                _dragValue = value;
              });
            },

            onChanged: (newValue) {
              setState(() {
                _dragValue = newValue;
              });
            },

            onChangeEnd: (newValue) async {
              await audioProvider.seek(
                Duration(milliseconds: newValue.toInt()),
              );

              setState(() {
                _dragValue = null;
              });
            },
          ),
        );
      },
    );
  }
}