class Sellers {
  String name;
  String email;
  String photoUrl;
  String uid;
  String rating;
  Sellers({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.uid,
    required this.rating,
  });

  factory Sellers.fromMap(Map<String, dynamic> data) {
    return Sellers(
      name: data['name'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      uid: data['uid'],
      rating: data['rating'],
    );
  }
}
