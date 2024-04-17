import 'package:bloc/bloc.dart';
import 'package:user_repository/user_repository.dart'; // Assurez-vous d'importer le repository nécessaire
import 'package:equatable/equatable.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(SignUpInitial());

  
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpRequired) {
      yield* _mapSignUpRequiredToState(event);
    }
  }

  Stream<SignUpState> _mapSignUpRequiredToState(SignUpRequired event) async* {
    yield SignUpProcess();
    try {
      MyUser myUser = await _userRepository.signUp(event.user, event.password);
      await _userRepository.setUserData(event.user);
      yield SignUpSuccess();
    } catch (e) {
      yield SignUpFailure();
    }
  }
}
