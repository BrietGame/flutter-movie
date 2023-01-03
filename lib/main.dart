import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:search_page/search_page.dart';
import 'dart:math';
import 'package:badges/badges.dart';

class Category implements Comparable<Category> {
  final String title;

  const Category(this.title);

  @override
  int compareTo(Category other) => title.compareTo(other.title);

  String getTitle() => title;
}

class Tag implements Comparable<Tag> {
  final String title;

  const Tag(this.title);

  @override
  int compareTo(Tag other) => title.compareTo(other.title);

  String getTitle() => title;
}

class Movie implements Comparable<Movie> {
  final String title;
  final int note;
  final Image image;
  final Category category;
  final List<Tag> tags;

  const Movie(this.title, this.note, this.image, this.category, this.tags);

  @override
  int compareTo(Movie other) => title.compareTo(other.title);

  String getTitle() => title;

  int getNote() => note;

  Image getImage() => image;

  Category getCategory() => category;
  setCategory(Category category) => category = category;

  List<Tag> getTags() => tags;
  setTags(List<Tag> tags) => tags = tags;
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
    const Categories = [
      Category('Action'),
      Category('Comedy'),
      Category('Drama'),
      Category('Horror'),
      Category('Romance'),
      Category('Thriller'),
    ];

    const Tags = [
      Tag('NFO'),
      Tag('HD'),
      Tag('VOSTFR'),
      Tag('VF'),
      Tag('Multi'),
      Tag('3D'),
      Tag('4K'),
      Tag('HDR'),
      Tag('Remux'),
      Tag('Bluray'),
      Tag('DVD'),
      Tag('WEB'),
      Tag('WEBRip'),
      Tag('WEB-DL'),
      Tag('HDTV'),
      Tag('TVRip'),
      Tag('TV'),
      Tag('TV-DL'),
      Tag('TV-rip'),
      Tag('TVRip'),
    ];

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
            final movie = Movie(generateTitle(), randomNote(), generateImage(), Categories[Random().nextInt(Categories.length)], [Tags[Random().nextInt(Tags.length)], Tags[Random().nextInt(Tags.length)], Tags[Random().nextInt(Tags.length)]]);
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
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                            child: movie.image,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Badge(
                              badgeColor: (movie.note >= 5 && movie.note <= 7) ? Colors.yellow : (movie.note > 7) ? Colors.green : Colors.red,
                              shape: BadgeShape.square,
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(15)),
                              badgeContent: Text(movie.note.toString(), style: const TextStyle(color: Colors.white, fontSize: 20)),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Center(child: Text(movie.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                          subtitle: Column(
                            children: [
                              Padding(padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Badge(
                                  badgeContent: Text(movie.category.title, style: const TextStyle(color: Colors.white)),
                                  badgeColor: Colors.deepPurple,
                                  shape: BadgeShape.square,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              Wrap(
                                children: movie.tags.map((tag) => Badge(
                                  badgeContent: Text(tag.title, style: const TextStyle(color: Colors.white)),
                                  badgeColor: Colors.indigo,
                                  shape: BadgeShape.square,
                                  borderRadius: BorderRadius.circular(5),
                                )).toList(),
                              ),
                            ],
                          ),
                        )
                      )
                    ],
                  )
              )
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
