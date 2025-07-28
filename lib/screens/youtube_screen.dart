import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'all_videos_screen.dart';
import 'video_player_screen.dart';



class YouTubeScreen extends StatefulWidget {
  @override
  _YouTubeScreenState createState() => _YouTubeScreenState();
}

class _YouTubeScreenState extends State<YouTubeScreen> {
  List<dynamic> _videos = [];
  bool _loading = true;

  // ✅ Your API Key and Channel ID
  final String apiKey = 'AIzaSyCgS9nE9dDXczKtn3KvuCIQPsBLXGXFSRY';
  final String channelId = 'UCAAoKbOmBN_CkXjyxrZyjqQ';

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    final playlistId = channelId.replaceRange(0, 2, 'UU');
    final url =
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playlistId&maxResults=10&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    setState(() {
      _videos = data['items']
          .where((video) {
            final snippet = video['snippet'];
            final thumbnail = snippet?['thumbnails']?['medium']?['url'];
            return snippet['resourceId']?['videoId'] != null &&
                thumbnail != null &&
                !thumbnail.endsWith('_live.jpg');
          })
          .toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.indigo[900],
    );

    if (_loading) return Center(child: CircularProgressIndicator());

    if (_videos.isEmpty) {
      return Center(child: Text("No videos available", style: titleStyle));
    }

    final limitedVideos = _videos.take(5).toList();
    final highlightedVideo = limitedVideos.first;
    final remainingVideos = limitedVideos.sublist(1);


    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Highlighted video
          GestureDetector(
            onTap: () {
              final videoId = highlightedVideo['snippet']['resourceId']['videoId'];
              final title = highlightedVideo['snippet']['title'];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(videoId: videoId, title: title),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    highlightedVideo['snippet']['thumbnails']['high']['url'],
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  highlightedVideo['snippet']['title'],
                  style: titleStyle.copyWith(fontSize: 16),
                ),
                const Divider(height: 32),
              ],
            ),
          ),

          // Remaining videos
          ...remainingVideos.map((video) {
            final snippet = video['snippet'];
            final videoId = snippet['resourceId']['videoId'];
            final title = snippet['title'];
            final thumbnail = snippet['thumbnails']['medium']['url'];

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  thumbnail,
                  width: 90,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                title,
                style: titleStyle,
              ),
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(videoId: videoId, title: title),
                ),
              );
            },          );
          }).toList(),
          // Show "See all" button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllVideosScreen()),
                  );
                },
                icon: Icon(Icons.list),
                label: Text('Ver todos os vídeos'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
