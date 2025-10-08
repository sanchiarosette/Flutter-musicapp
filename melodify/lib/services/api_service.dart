import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Data Models
class User {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
    );
  }
}

class ImageData {
  final String quality;
  final String url;

  ImageData({
    required this.quality,
    required this.url,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      quality: json['quality'],
      url: json['url'],
    );
  }
}

class DownloadUrl {
  final String quality;
  final String url;

  DownloadUrl({
    required this.quality,
    required this.url,
  });

  factory DownloadUrl.fromJson(Map<String, dynamic> json) {
    return DownloadUrl(
      quality: json['quality'],
      url: json['url'],
    );
  }
}

class Album {
  final String? id;
  final String? name;
  final String? url;

  Album({
    this.id,
    this.name,
    this.url,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'],
      url: json['url'],
    );
  }
}

class Artist {
  final String id;
  final String name;
  final String role;
  final String type;
  final List<ImageData> image;
  final String url;

  Artist({
    required this.id,
    required this.name,
    required this.role,
    required this.type,
    required this.image,
    required this.url,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Artist',
      role: json['role'] ?? 'artist',
      type: json['type'] ?? 'artist',
      image: json['image'] != null
          ? (json['image'] as List).map((i) => ImageData.fromJson(i)).toList()
          : [],
      url: json['url'] ?? '',
    );
  }
}

class Song {
  final String id;
  final String name;
  final String type;
  final String? year;
  final String? releaseDate;
  final int? duration;
  final String? label;
  final bool explicitContent;
  final int? playCount;
  final String language;
  final bool hasLyrics;
  final String? lyricsId;
  final String url;
  final String? copyright;
  final String album;
  final String primaryArtists;
  final String singers;
  final List<ImageData> image;
  final List<DownloadUrl> downloadUrl;

  Song({
    required this.id,
    required this.name,
    required this.type,
    this.year,
    this.releaseDate,
    this.duration,
    this.label,
    required this.explicitContent,
    this.playCount,
    required this.language,
    required this.hasLyrics,
    this.lyricsId,
    required this.url,
    this.copyright,
    required this.album,
    required this.primaryArtists,
    required this.singers,
    required this.image,
    required this.downloadUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    try {
      return Song(
        id: json['id'] ?? '',
        name: json['name'] ?? json['title'] ?? 'Unknown Song',
        type: json['type'] ?? 'song',
        year: json['year'],
        releaseDate: json['releaseDate'],
        duration: json['duration'],
        label: json['label'],
        explicitContent: json['explicitContent'] ?? false,
        playCount: json['playCount'],
        language: json['language'] ?? 'english',
        hasLyrics: json['hasLyrics'] ?? false,
        lyricsId: json['lyricsId'],
        url: json['url'] ?? '',
        copyright: json['copyright'],
        album: json['album'] ?? 'Unknown Album',
        primaryArtists: json['primaryArtists'] ?? 'Unknown Artist',
        singers: json['singers'] ?? 'Unknown Artist',
        image: json['image'] != null
            ? (json['image'] as List).map((i) => ImageData.fromJson(i)).toList()
            : [],
        downloadUrl: json['downloadUrl'] != null
            ? (json['downloadUrl'] as List).map((d) => DownloadUrl.fromJson(d)).toList()
            : [],
      );
    } catch (e) {
      // Error parsing song JSON
      rethrow;
    }
  }

  // Helper methods for compatibility
  String get title => name;
  String get artist => primaryArtists;
  String get audioUrl => downloadUrl.isNotEmpty ? downloadUrl.first.url : '';
  Duration get durationTime => Duration(seconds: duration ?? 0);
  String? get coverUrl => image.isNotEmpty ? image.first.url : null;
}

class Playlist {
  final String id;
  final String name;
  final String? description;
  final String? coverUrl;
  final List<String> songIds;

  Playlist({
    required this.id,
    required this.name,
    this.description,
    this.coverUrl,
    required this.songIds,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      coverUrl: json['cover_url'],
      songIds: List<String>.from(json['song_ids']),
    );
  }
}

class ApiService {
  static const String baseUrl = 'https://saavn.dev/api';
  static const String tokenKey = 'auth_token';

  final http.Client _client = http.Client();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  // Authentication
  Future<User> login(String email, String password) async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (email == 'test@example.com' && password == 'password') {
      final user = User(
        id: '1',
        email: email,
        name: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
      );
      await setToken('mock_token');
      return user;
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<User> register(String email, String password, String name) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));

    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );
    await setToken('mock_token');
    return user;
  }

  Future<void> logout() async {
    await clearToken();
  }

  // Songs
  Future<List<Song>> getSongs() async {
    try {
      // Try to get real songs from Jio Saavan API using global search
      final response = await _client.get(
        Uri.parse('$baseUrl/search?query=popular'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final songs = data['data']['songs']['results'] as List?;
          if (songs != null && songs.isNotEmpty) {
            return songs.map((song) => Song.fromJson(song)).toList();
          }
        }
      }
    } catch (e) {
      // Fallback to mock data if API fails
    }

    // Mock data as fallback
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Song(
        id: '1',
        name: 'Blinding Lights',
        type: 'song',
        year: '2020',
        releaseDate: '2020-03-20',
        duration: 200,
        label: 'Republic Records',
        explicitContent: false,
        playCount: 1000000,
        language: 'english',
        hasLyrics: true,
        lyricsId: null,
        url: 'https://www.jiosaavn.com/song/blinding-lights',
        copyright: '© 2020 Republic Records',
        album: 'After Hours',
        primaryArtists: 'The Weeknd',
        singers: 'The Weeknd',
        image: [ImageData(quality: '500x500', url: 'https://c.saavncdn.com/After-Hours-English-2020-20200320181137-500x500.jpg')],
        downloadUrl: [DownloadUrl(quality: '320kbps', url: 'https://www2.cs.uic.edu/~i101/SoundFiles/PinkPanther30.wav')],
      ),
      Song(
        id: '2',
        name: 'Watermelon Sugar',
        type: 'song',
        year: '2019',
        releaseDate: '2019-11-17',
        duration: 174,
        label: 'Columbia Records',
        explicitContent: false,
        playCount: 800000,
        language: 'english',
        hasLyrics: true,
        lyricsId: null,
        url: 'https://www.jiosaavn.com/song/watermelon-sugar',
        copyright: '© 2019 Columbia Records',
        album: 'Fine Line',
        primaryArtists: 'Harry Styles',
        singers: 'Harry Styles',
        image: [ImageData(quality: '500x500', url: 'https://c.saavncdn.com/Fine-Line-English-2019-20191104134623-500x500.jpg')],
        downloadUrl: [DownloadUrl(quality: '320kbps', url: 'https://www2.cs.uic.edu/~i101/SoundFiles/PinkPanther30.wav')],
      ),
    ];
  }

  Future<List<Song>> searchSongs(String query) async {
    try {
      // Try to search using Jio Saavan API global search
      final response = await _client.get(
        Uri.parse('$baseUrl/search?query=$query'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final songs = data['data']['songs']['results'] as List?;
          if (songs != null && songs.isNotEmpty) {
            return songs.map((song) => Song.fromJson(song)).toList();
          }
        }
      }
    } catch (e) {
      // Fallback to mock search if API fails
    }

    // Mock search as fallback
    final allSongs = await getSongs();
    return allSongs.where((song) =>
        song.title.toLowerCase().contains(query.toLowerCase()) ||
        song.artist.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Playlists
  Future<List<Playlist>> getPlaylists() async {
    // Mock data
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Playlist(
        id: '1',
        name: 'My Favorites',
        description: 'My favorite songs',
        songIds: ['1', '2'],
      ),
    ];
  }

  Future<Playlist> createPlaylist(String name, String? description) async {
    // Mock
    await Future.delayed(const Duration(milliseconds: 500));
    return Playlist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      songIds: [],
    );
  }

  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    // Mock
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // For actual API integration, replace mock implementations with real HTTP calls
  // Example:
  // Future<User> login(String email, String password) async {
  //   final response = await _client.post(
  //     Uri.parse('$baseUrl/auth/login'),
  //     headers: await _getHeaders(),
  //     body: jsonEncode({'email': email, 'password': password}),
  //   );
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     await setToken(data['token']);
  //     return User.fromJson(data['user']);
  //   } else {
  //     throw Exception('Login failed');
  //   }
  // }
}