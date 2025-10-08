import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/music_provider.dart';
import '../theme/colors.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(musicPlayerProvider);

    return Positioned(
      bottom: 80, // Above navigation bar
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1.0,
              ),
            ),
            child: playerState.currentSong == null
                ? const Center(
                    child: Text(
                      'Tap a song to start playing',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      // Album art
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: playerState.currentSong!.coverUrl != null
                              ? DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      playerState.currentSong!.coverUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: AppColors.surfaceLight,
                        ),
                        child: playerState.currentSong!.coverUrl == null
                            ? const Icon(
                                Icons.music_note,
                                color: AppColors.primaryPink,
                                size: 24,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      // Song info
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playerState.currentSong!.title,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              playerState.currentSong!.artist,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Controls
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              ref.read(musicPlayerProvider.notifier).previous();
                            },
                            icon: const Icon(
                              Icons.skip_previous,
                              color: AppColors.textPrimary,
                              size: 28,
                            ),
                          ),
                          IconButton(
                            onPressed: playerState.isPlaying
                                ? () => ref.read(musicPlayerProvider.notifier).pause()
                                : () => ref.read(musicPlayerProvider.notifier).resume(),
                            icon: Icon(
                              playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: AppColors.primaryPink,
                              size: 32,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ref.read(musicPlayerProvider.notifier).next();
                            },
                            icon: const Icon(
                              Icons.skip_next,
                              color: AppColors.textPrimary,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}