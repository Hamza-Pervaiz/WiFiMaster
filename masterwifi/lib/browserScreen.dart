import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Browserscreen extends StatefulWidget {
  const Browserscreen({super.key});

  @override
  State<Browserscreen> createState() => _BrowserscreenState();
}

class _BrowserscreenState extends State<Browserscreen> {
  final List<Map<String, String>> hotSearches = [
    {"title": "Donald Trump hurls insults in NY fraud trial", "status": "hot"},
    {"title": "Chargers vs. Jets Monday Night Football", "status": "hot"},
    {"title": "No. 18 Colorado stuns No. 1 LSU, trouncing", "status": "hot"},
    {"title": "Man in S. Korea arrested for assaulting woman", "status": "hot"},
    {"title": "Indonesia says Gaza hospital for Palestinians", "status": "hot"},
    {"title": "Brooke Shields had a grand mal seizure", "status": "hot"},
    {"title": "Deadly attacks on Gaza camps as Blinken", "status": "hot"},
    {"title": "Donald Trump to take the stand", "status": "hot"},
    {"title": "Parts of Iowa, Nebraska, and New York", "status": "hot"},
    {"title": "Shahidan wants Pakatan MP referred", "status": "hot"},
    {"title": "Heavy traffic expected at S’pore-Malays", "status": "hot"},
    {"title": "The Big Picture: Today's Hot Photos", "status": "hot"},
  ];

  // Method to launch URLs
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search or Enter URL',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.search, color: Colors.grey),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.video_library),
                  onPressed: () => _launchURL('https://www.youtube.com'),
                ),
                IconButton(
                  icon: Icon(Icons.facebook),
                  onPressed: () => _launchURL('https://www.facebook.com'),
                ),
                IconButton(
                  icon: Icon(Icons.abc),
                  onPressed: () => _launchURL('https://www.twitter.com'),
                ),
                IconButton(
                  icon: Icon(Icons.public),
                  onPressed: () => _launchURL('https://www.wikipedia.org'),
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => _launchURL('https://www.amazon.com'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.video_library),
                  onPressed: () => _launchURL('https://www.youtube.com/'),
                ),
                IconButton(
                  icon: Icon(Icons.facebook),
                  onPressed: () => _launchURL('https://www.facebook.com'),
                ),
                IconButton(
                  icon: Icon(Icons.abc),
                  onPressed: () => _launchURL('https://www.twitter.com'),
                ),
                IconButton(
                  icon: Icon(Icons.public),
                  onPressed: () => _launchURL('https://www.wikipedia.org'),
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => _launchURL('https://www.amazon.com'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Hot Search List
            Expanded(
              child: ListView.builder(
                itemCount: hotSearches.length,
                itemBuilder: (context, index) {
                  final item = hotSearches[index];
                  return ListTile(
                    title: InkWell(
                      onTap: () {
                        // Handle click event for hot search item
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('You clicked: ${item["title"]}'),
                        ));
                      },
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}. ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              item["title"]!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          if (item["status"] == "hot")
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'HOT',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
