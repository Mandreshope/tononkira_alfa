bool isValidateEmail(String email) =>
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

bool isValidatePassword(String passd) =>
    RegExp("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}").hasMatch(passd);

bool isValidateConfirmationPassword(String pass, String passC) {
  if(pass != passC) {
    return false;
  }else {
    return true;
  }
}