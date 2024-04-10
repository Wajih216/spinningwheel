part of 'authentication_bloc.dart';

enum AuthenticationSatus { unknown, authenticated, unauthenticated }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationSatus.unknown,
    this.user 
  });

  
  final AuthenticationSatus status;
  final MyUser? user;

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(MyUser user) : this._(
    status: AuthenticationSatus.authenticated,
    user: user
  );

  const AuthenticationState.unauthenticated() : this._(
    status: AuthenticationSatus.unauthenticated
  );

  @override
  List<Object?> get props => [status, user];
}