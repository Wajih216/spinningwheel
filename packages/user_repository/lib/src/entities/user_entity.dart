
class MyUserEntity {
  String userId;
  String email;
  String name ; 
   
  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
  });

  Map<String,Object?> toDocument(){
    return {
      'userId': userId,
      'email': email,
      'name': name
    };
  }

  static MyUserEntity fromDocument(Map<String,dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'] as String,
      email: doc['email'] as String,
      name: doc['name'] as String
    );
  }


}