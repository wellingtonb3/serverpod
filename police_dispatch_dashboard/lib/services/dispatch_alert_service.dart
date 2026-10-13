import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Repeats distinct tones while response units are travelling to incidents.
class DispatchAlertService {
  static const _alertInterval = Duration(seconds: 5);
  static final AudioPlayer _policePlayer = AudioPlayer();
  static final AudioPlayer _firePlayer = AudioPlayer();
  static bool _policeLooping = false;
  static bool _fireLooping = false;
  static Uint8List? _policeTone;
  static Uint8List? _fireTone;
  static bool _completionListenersConfigured = false;

  static Future<void> updatePoliceDispatchState(bool hasDispatchedUnit) async {
    await _updateLoop(
      player: _policePlayer,
      shouldLoop: hasDispatchedUnit,
      isLooping: _policeLooping,
      setLooping: (value) => _policeLooping = value,
      bytes: _tone(frequencies: [880, 1175]),
    );
  }

  static Future<void> updateFireDispatchState(bool hasDispatchedUnit) async {
    await _updateLoop(
      player: _firePlayer,
      shouldLoop: hasDispatchedUnit,
      isLooping: _fireLooping,
      setLooping: (value) => _fireLooping = value,
      bytes: _tone(frequencies: [1175, 880]),
    );
  }

  static Future<void> _updateLoop({
    required AudioPlayer player,
    required bool shouldLoop,
    required bool isLooping,
    required void Function(bool value) setLooping,
    required Uint8List bytes,
  }) async {
    _configureCompletionListeners();
    if (shouldLoop == isLooping) return;

    setLooping(shouldLoop);
    try {
      if (shouldLoop) {
        await player.setReleaseMode(ReleaseMode.stop);
        await player.play(BytesSource(bytes));
      } else {
        await player.stop();
      }
    } on Object catch (error, stackTrace) {
      setLooping(false);
      debugPrint('Could not play dispatch alert: $error\n$stackTrace');
    }
  }

  static void _configureCompletionListeners() {
    if (_completionListenersConfigured) return;
    _completionListenersConfigured = true;
    _policeTone = _tone(frequencies: [880, 1175]);
    _fireTone = _tone(frequencies: [1175, 880]);
    _policePlayer.onPlayerComplete.listen(
      (_) => _replayWhileDispatched(
        _policePlayer,
        () => _policeLooping,
        _policeTone,
      ),
    );
    _firePlayer.onPlayerComplete.listen(
      (_) => _replayWhileDispatched(_firePlayer, () => _fireLooping, _fireTone),
    );
  }

  static Future<void> _replayWhileDispatched(
    AudioPlayer player,
    bool Function() isLooping,
    Uint8List? bytes,
  ) async {
    await Future<void>.delayed(_alertInterval);
    if (!isLooping() || bytes == null) return;
    try {
      await player.play(BytesSource(bytes));
    } on Object catch (error, stackTrace) {
      debugPrint('Could not repeat dispatch alert: $error\n$stackTrace');
    }
  }

  static Uint8List _tone({
    required List<double> frequencies,
    int sampleRate = 44100,
    int millisecondsPerNote = 120,
  }) {
    final samplesPerNote = sampleRate * millisecondsPerNote ~/ 1000;
    final sampleCount = samplesPerNote * frequencies.length;
    final dataLength = sampleCount * 2;
    final bytes = ByteData(44 + dataLength);

    void writeAscii(int offset, String value) {
      for (var i = 0; i < value.length; i++) {
        bytes.setUint8(offset + i, value.codeUnitAt(i));
      }
    }

    writeAscii(0, 'RIFF');
    bytes.setUint32(4, 36 + dataLength, Endian.little);
    writeAscii(8, 'WAVE');
    writeAscii(12, 'fmt ');
    bytes.setUint32(16, 16, Endian.little);
    bytes.setUint16(20, 1, Endian.little);
    bytes.setUint16(22, 1, Endian.little);
    bytes.setUint32(24, sampleRate, Endian.little);
    bytes.setUint32(28, sampleRate * 2, Endian.little);
    bytes.setUint16(32, 2, Endian.little);
    bytes.setUint16(34, 16, Endian.little);
    writeAscii(36, 'data');
    bytes.setUint32(40, dataLength, Endian.little);

    var offset = 44;
    for (var note = 0; note < frequencies.length; note++) {
      for (var sample = 0; sample < samplesPerNote; sample++) {
        final progress = sample / samplesPerNote;
        final envelope =
            math.min(1, sample / (sampleRate * 0.01)) *
            math.min(1, (1 - progress) * 12);
        final value =
            math.sin(2 * math.pi * frequencies[note] * sample / sampleRate) *
            envelope *
            0.35;
        bytes.setInt16(offset, (value * 32767).round(), Endian.little);
        offset += 2;
      }
    }
    return bytes.buffer.asUint8List();
  }
}
