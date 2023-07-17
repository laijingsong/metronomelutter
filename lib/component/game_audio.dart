import 'package:audioplayers/audioplayers.dart';

class GameAudio {
  List<AudioPlayer> audioPlayers = [];

  List files;
  int maxPlayers;

  GameAudio(this.maxPlayers, {required this.files});

  Future init() async {
    for (int i = 0; i < maxPlayers; i++) {
      audioPlayers.add(await _createNewAudioPlayer());
    }
  }

  Future play(String file, {volume = 1.0}) async {
    for (int i = 0; i < maxPlayers; i++) {
      /*if (audioCaches[i].fixedPlayer.state == AudioPlayerState.PLAYING) {
        audioCaches[i].fixedPlayer.stop();
      }*/
      //return audioCaches[i].play(file, volume: volume, mode: PlayerMode.LOW_LATENCY);
      audioPlayers[i].play(AssetSource(file));
    }
  }

  Future stop() async {
    for (int i = 0; i < maxPlayers; i++) {
      // if (audioCaches[i].fixedPlayer.state == AudioPlayerState.PLAYING) {
      //audioCaches[i].fixedPlayer.stop();
      // }
      audioPlayers[i].stop();
    }
  }

  Future _createNewAudioPlayer() async {
    /*final AudioCache audioCache = AudioCache(
        // prefix: 'audio/',
        fixedPlayer: AudioPlayer());
    await audioCache.fixedPlayer.setReleaseMode(ReleaseMode.STOP);
    // await audioCache.loadAll(files);
    return audioCache;*/
    return AudioPlayer();
  }

  /// Clears all the audios in the cache
  void clearAll() {
    /*audioCaches.forEach((audioCache) {
      audioCache.clearCache();
    });*/
    audioPlayers.forEach((audioPlay) {
      audioPlay.dispose();
    });
  }

  /// Disables audio related logs
  void disableLog() {
    /*audioCaches.forEach((audioCache) {
      audioCache.disableLog();
    });*/
  }
}
