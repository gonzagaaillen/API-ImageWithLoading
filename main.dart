import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: const ImageGallery(),
      routes: {
        '/second': (context) => const SecondPage(),
      },
    );
  }
}

class ImageGallery extends StatefulWidget {
  const ImageGallery({Key? key}) : super(key: key);

  @override
  ImageGalleryState createState() => ImageGalleryState();
}

class ImageGalleryState extends State<ImageGallery> {
  final List<Map<String, dynamic>> imageList = [
    {
      'id': 1,
      'imageUrl': 'https://picsum.photos/id/25/1543/2922',
      'photoName': 'Beautiful tree',
    },
    {
      'id': 2,
      'imageUrl': 'https://picsum.photos/id/867/1431/2747',
      'photoName': 'Sunset',
    },
    {
      'id': 3,
      'imageUrl': 'https://picsum.photos/id/654/1021/2962',
      'photoName': 'Night View',
    },
    {
      'id': 4,
      'imageUrl': 'https://picsum.photos/id/683/1342/2873',
      'photoName': 'Meteor Stars',
    },
    {
      'id': 5,
      'imageUrl': 'https://picsum.photos/id/613/1123/1893',
      'photoName': 'Bridge',
    },
    {
      'id': 6,
      'imageUrl': 'https://picsum.photos/id/435/962/2367',
      'photoName': 'FujiFilm',
    },
    {
      'id': 7,
      'imageUrl': 'https://picsum.photos/id/559/1049/1311',
      'photoName': 'Snow',
    },
    {
      'id': 8,
      'imageUrl': 'https://picsum.photos/id/534/1538/2194',
      'photoName': 'Going Grind',
    },
    {
      'id': 9,
      'imageUrl': 'https://picsum.photos/id/36/893/1714',
      'photoName': 'Disassemble',
    },
    {
      'id': 10,
      'imageUrl': 'https://picsum.photos/id/824/1618/2146',
      'photoName': 'Pineapple',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.image),
        title: const Text('Image Gallery'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Padding around the grid
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            final imageUrl = imageList[index]['imageUrl'];
            final photoName = imageList[index]['photoName'];

            return GridTile(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/second',
                    arguments: {
                      'imageUrl': imageUrl,
                      'photoName': photoName,
                    },
                  );
                },
                child: ImageWidget(imageUrl: imageUrl),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ImageWidget extends StatefulWidget {
  final String imageUrl;

  const ImageWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  ImageWidgetState createState() => ImageWidgetState();
}

class ImageWidgetState extends State<ImageWidget> {
  Uint8List? imageData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(widget.imageUrl));
    if (response.statusCode == 200) {
      setState(() {
        imageData = response.bodyBytes;
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: imageData != null
          ? Image.memory(imageData!, fit: BoxFit.cover)
          : const CircularProgressIndicator(),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String imageUrl = arguments['imageUrl'];
    final String photoName = arguments['photoName'];

    return Scaffold(
      appBar: AppBar(
        title: Text(photoName),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: ImageWidget(imageUrl: imageUrl),
      ),
    );
  }
}