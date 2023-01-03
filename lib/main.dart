import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:search_page/search_page.dart';
import 'dart:math';

class Movie implements Comparable<Movie> {
  final String title;
  final int note;
  final Image image;

  const Movie(this.title, this.note, this.image);

  @override
  int compareTo(Movie other) => title.compareTo(other.title);

  String getTitle() => title;

  int getNote() => note;

  Image getImage() => image;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Films',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const Movies(),
    );
  }
}

class Movies extends StatefulWidget {
  const Movies({Key? key}) : super(key: key);

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  final _listMovies = [];

  int randomNote() {
    var random = Random();
    return random.nextInt(10);
  }

  String generateTitle() {
    return WordPair.random().asPascalCase;
  }

  Image generateImage() {
    int id = Random().nextInt(1000);
    return Image.network(
      'https://picsum.photos/id/${id}/200/100?random=1',
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des films"),
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, i) {
            final movie = Movie(generateTitle(), randomNote(), generateImage());
            _listMovies.add(movie);

            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MovieDetail(titleMovie: movie.title, note: movie.note, image: movie.image))
                );
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            child: movie.image,
                          ),
                        ),
                        ListTile(
                          title: Text(movie.title),
                          trailing: CircleAvatar(
                            backgroundColor: (movie.note >= 5 && movie.note <= 7) ? Colors.yellow : (movie.note > 7) ? Colors.green : Colors.red,
                            child: Text(movie.note.toString()),
                          ),
                        ),
                      ]
                  )
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () => showSearch(
            context: context,
            delegate: SearchPage(
                builder: (movie) => ListTile(
                  title: Text(movie.title),
                  trailing: CircleAvatar(
                    backgroundColor: (movie.note >= 5 && movie.note <= 7) ? Colors.yellow : (movie.note > 7) ? Colors.green : Colors.red,
                    child: Text(movie.note.toString()),
                  ),
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MovieDetail(titleMovie: movie.title, note: movie.note, image: movie.image))
                    );
                  },
                ),
                filter: (movie) => [movie.title],
                items: _listMovies.toList(),
                searchLabel: 'Rechercher un film',
                suggestion: const Center(
                  child: Text('Rechercher un film'),
                ),
                failure: const Center(
                  child: Text('Aucun film trouvé'),
                ),
            ),
        ),
      ),
    );
  }
}

class MovieDetail extends StatefulWidget {
  const MovieDetail({required this.titleMovie, required this.note, this.image});

  final String titleMovie;
  final int note;
  final Image? image;

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleMovie),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: widget.image,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(widget.titleMovie),
              margin: EdgeInsets.all(20),
            ),
            CircleAvatar(
              backgroundColor: (widget.note >= 5 && widget.note <= 7) ? Colors.yellow : (widget.note > 7) ? Colors.green : Colors.red,
              child: Text(widget.note.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
