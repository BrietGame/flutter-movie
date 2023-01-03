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

  setCategorie(Categorie categorie) => category = categorie;
}