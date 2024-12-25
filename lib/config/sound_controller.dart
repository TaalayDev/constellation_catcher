import 'dart:async';

import 'package:constellation_catcher/config/assets.dart';
import 'package:just_audio/just_audio.dart';

class SoundController {
  static final SoundController _instance = SoundController._internal();
  factory SoundController() => _instance;

  SoundController._internal() {
    _initializeAudio();
  }

  // Audio players
  final AudioPlayer _musicPlayer = AudioPlayer();
  final Map<String, AudioPlayer> _soundPlayers = {};

  // Volume settings
  double _musicVolume = 0.3;
  double _soundEffectsVolume = 1.0;
  bool _isMuted = false;

  // Sound assets
  static final _sounds = {
    'click': Assets.audio.click,
  };

  // Background music tracks
  static final _musicTracks = {
    'menu': Assets.audio.menuMusic,
    'game': Assets.audio.gameMusic,
  };

  Future<void> _initializeAudio() async {
    // Initialize sound players
    for (final sound in _sounds.keys) {
      _soundPlayers[sound] = AudioPlayer();
      await _soundPlayers[sound]?.setAsset(_sounds[sound]!);
      _soundPlayers[sound]?.setVolume(_soundEffectsVolume);
    }

    // Configure music player for looping
    await _musicPlayer.setLoopMode(LoopMode.all);
    _musicPlayer.setVolume(_musicVolume);
  }

  // Music control methods
  Future<void> playBackgroundMusic(
    String track, {
    Duration fadeInDuration = const Duration(seconds: 3),
  }) async {
    if (!_musicTracks.containsKey(track)) return;

    final completer = Completer<void>();

    // Stop current music if playing
    await _musicPlayer.stop();

    // Set up the new track
    await _musicPlayer.setAsset(_musicTracks[track]!);
    await _musicPlayer.setVolume(0.0); // Start silent
    _musicPlayer.play().then((_) => completer.complete());

    // Gradually increase volume
    if (!_isMuted) {
      const intervalDuration = Duration(milliseconds: 50);
      final steps =
          fadeInDuration.inMilliseconds ~/ intervalDuration.inMilliseconds;
      final volumeIncrement = _musicVolume / steps;

      double currentVolume = 0;
      for (int i = 0; i < steps; i++) {
        await Future.delayed(intervalDuration);
        currentVolume =
            (currentVolume + volumeIncrement).clamp(0.0, _musicVolume);
        _musicPlayer.setVolume(currentVolume);
      }

      // Ensure we reach the target volume
      _musicPlayer.setVolume(_musicVolume);
    }

    return completer.future;
  }

  Future<void> stopBackgroundMusic({
    Duration fadeOutDuration = const Duration(seconds: 2),
  }) async {
    if (!_musicPlayer.playing) return;

    // Gradually decrease volume
    final currentVolume = _musicPlayer.volume;
    const intervalDuration = Duration(milliseconds: 50);
    final steps =
        fadeOutDuration.inMilliseconds ~/ intervalDuration.inMilliseconds;
    final volumeDecrement = currentVolume / steps;

    double volume = currentVolume;
    for (int i = 0; i < steps; i++) {
      await Future.delayed(intervalDuration);
      volume = (volume - volumeDecrement).clamp(0.0, _musicVolume);
      _musicPlayer.setVolume(volume);
    }

    // Ensure volume is 0 and stop playback
    await _musicPlayer.setVolume(0);
    await _musicPlayer.stop();
  }

  Future<void> pauseBackgroundMusic({
    Duration fadeOutDuration = const Duration(milliseconds: 500),
  }) async {
    // Store current volume for resume
    final currentVolume = _musicPlayer.volume;

    // Fade out
    await stopBackgroundMusic(fadeOutDuration: fadeOutDuration);

    // Store the volume we'll need when resuming
    _musicVolume = currentVolume;
  }

  Future<void> resumeBackgroundMusic({
    Duration fadeInDuration = const Duration(milliseconds: 500),
  }) async {
    if (!_isMuted) {
      await _musicPlayer.play();

      // Gradually increase volume back to stored level
      const intervalDuration = Duration(milliseconds: 50);
      final steps =
          fadeInDuration.inMilliseconds ~/ intervalDuration.inMilliseconds;
      final volumeIncrement = _musicVolume / steps;

      double currentVolume = 0;
      for (int i = 0; i < steps; i++) {
        await Future.delayed(intervalDuration);
        currentVolume =
            (currentVolume + volumeIncrement).clamp(0.0, _musicVolume);
        _musicPlayer.setVolume(currentVolume);
      }

      // Ensure we reach the target volume
      _musicPlayer.setVolume(_musicVolume);
    }
  }

  // Sound effect methods
  Future<void> playSound(String sound) async {
    if (_isMuted || !_soundPlayers.containsKey(sound)) return;

    final player = _soundPlayers[sound];
    if (player != null) {
      await player.seek(Duration.zero);
      await player.play();
    }
  }

  // Volume control methods
  void setMusicVolume(double volume) {
    _musicVolume = volume;
    _musicPlayer.setVolume(_isMuted ? 0 : volume);
  }

  void setSoundEffectsVolume(double volume) {
    _soundEffectsVolume = volume;
    for (final player in _soundPlayers.values) {
      player.setVolume(_isMuted ? 0 : volume);
    }
  }

  void setMuted(bool muted) {
    _isMuted = muted;
    _musicPlayer.setVolume(muted ? 0 : _musicVolume);
    for (final player in _soundPlayers.values) {
      player.setVolume(muted ? 0 : _soundEffectsVolume);
    }
  }

  // Resource management
  Future<void> dispose() async {
    await _musicPlayer.dispose();
    for (final player in _soundPlayers.values) {
      await player.dispose();
    }
    _soundPlayers.clear();
  }

  // Getters for current state
  bool get isMuted => _isMuted;
  double get musicVolume => _musicVolume;
  double get soundEffectsVolume => _soundEffectsVolume;
  bool get isMusicPlaying => _musicPlayer.playing;
}
