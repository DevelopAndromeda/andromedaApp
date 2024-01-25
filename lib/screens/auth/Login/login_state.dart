import 'package:andromeda/Util/validation_item.dart';
class LoginState{
  ValidationItem email;
  ValidationItem password;

  LoginState ({
    this.email = const ValidationItem(),
    this.password = const ValidationItem()
  });


  LoginState copywith ({
    ValidationItem? email,
    ValidationItem? password
}) => LoginState(
      email: email ?? this.email,
      password: password?? this.password
 
    );
  //Estados de validacion de los datos 

  bool isValid(){
    if (
    email.value.isEmpty ||
    email.error.isNotEmpty ||
    password.value.isEmpty ||
    password.error.isNotEmpty
    )
    { 
      return false;
    }
      return true;
    }

}