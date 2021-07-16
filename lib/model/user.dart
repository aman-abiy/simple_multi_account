class User {
  final String email;
  final String loggedInAt;

  User(this.email, this.loggedInAt);

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'loggedInAt': loggedInAt,
    };
  }

}