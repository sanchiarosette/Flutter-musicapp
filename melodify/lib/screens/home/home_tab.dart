import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/music_provider.dart';
import '../../widgets/song_card.dart';
import '../../theme/colors.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(songsProvider);

    return songsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryPink,
        ),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Error loading songs: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
      data: (songs) => ListView.builder(
        padding: const EdgeInsets.only(top: 100, bottom: 100), // Account for app bar and nav bar
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return SongCard(
            song: song,
            onTap: () {
              ref.read(musicPlayerProvider.notifier).playSong(song, queue: songs, index: index);
            },
          );
        },
      ),
    );
  }
}