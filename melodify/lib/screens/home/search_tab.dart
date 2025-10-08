import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/music_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/song_card.dart';
import '../../widgets/frosted_card.dart';
import '../../theme/colors.dart';

class SearchTab extends ConsumerStatefulWidget {
  const SearchTab({super.key});

  @override
  ConsumerState<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends ConsumerState<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Song> _searchResults = [];
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final songsAsync = ref.watch(songsProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 100), // Account for app bar
          FrostedCard(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search songs, artists...',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                border: InputBorder.none,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isSearching
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryPink),
                  )
                : songsAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: AppColors.primaryPink),
                    ),
                    error: (error, stack) => Center(
                      child: Text(
                        'Error: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    data: (songs) {
                      final displaySongs = _searchResults.isNotEmpty ? _searchResults : songs;
                      if (displaySongs.isEmpty && _searchController.text.isNotEmpty) {
                        return const Center(
                          child: Text(
                            'No songs found',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: displaySongs.length,
                        itemBuilder: (context, index) {
                          final song = displaySongs[index];
                          return SongCard(
                            song: song,
                            onTap: () {
                              ref.read(musicPlayerProvider.notifier).playSong(song, queue: displaySongs);
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    if (query.length < 2) return; // Don't search for very short queries

    setState(() {
      _isSearching = true;
    });

    try {
      final apiService = ref.read(apiServiceProvider);
      final results = await apiService.searchSongs(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      // Fallback to local search
      final songsAsync = ref.read(songsProvider);
      songsAsync.whenData((songs) {
        final results = songs.where((song) =>
            song.title.toLowerCase().contains(query.toLowerCase()) ||
            song.artist.toLowerCase().contains(query.toLowerCase())).toList();
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}