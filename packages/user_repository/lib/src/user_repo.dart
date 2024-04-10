abstract class UserRepository {
  Stream<MyUser?> get user;
  Future<MyUser> signUp(MyUser myUser , String password); 
  Future<void> signIn(String email , String password);
  Future<void> setUserData(MyUser user);
  Future<void> signOut();
}