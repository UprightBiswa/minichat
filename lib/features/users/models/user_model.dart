class User {
  final String id;
  final String name;

  User(this.name) : id = DateTime.now().millisecondsSinceEpoch.toString();
}
