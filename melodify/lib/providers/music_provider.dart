import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

// Music player state
class MusicPlayerState {
  final Song? currentSong;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final List<Song> queue;
  final int currentIndex;

  const MusicPlayerState({
    this.currentSong,
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.queue = const [],
    this.currentIndex = -1,
  });

  MusicPlayerState copyWith({
    Song? currentSong,
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    Duration? duration,
    List<Song>? queue,
    int? currentIndex,
  }) {
    return MusicPlayerState(
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class MusicPlayerNotifier extends StateNotifier<MusicPlayerState> {
  final AudioPlayer _audioPlayer;

  MusicPlayerNotifier(this._audioPlayer) : super(const MusicPlayerState()) {
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        state = state.copyWith(duration: duration);
      }
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      state = state.copyWith(
        isPlaying: playerState.playing,
        isLoading: playerState.processingState == ProcessingState.loading,
      );
    });
  }

  Future<void> playSong(Song song, {List<Song>? queue, int index = 0}) async {
    state = state.copyWith(
      currentSong: song,
      queue: queue ?? [song],
      currentIndex: index,
      isLoading: true,
    );

    try {
      await _audioPlayer.setUrl(song.audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Handle error
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> next() async {
    if (state.currentIndex < state.queue.length - 1) {
      final nextIndex = state.currentIndex + 1;
      final nextSong = state.queue[nextIndex];
      await playSong(nextSong, queue: state.queue, index: nextIndex);
    }
  }

  Future<void> previous() async {
    if (state.currentIndex > 0) {
      final prevIndex = state.currentIndex - 1;
      final prevSong = state.queue[prevIndex];
      await playSong(prevSong, queue: state.queue, index: prevIndex);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

// Music data providers
final songsProvider = FutureProvider<List<Song>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getSongs();
});

final playlistsProvider = FutureProvider<List<Playlist>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getPlaylists();
});

// Music player provider
final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  return AudioPlayer();
});

final musicPlayerProvider = StateNotifierProvider<MusicPlayerNotifier, MusicPlayerState>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return MusicPlayerNotifier(audioPlayer);
});