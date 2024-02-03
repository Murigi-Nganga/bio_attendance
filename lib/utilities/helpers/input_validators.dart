String? validateName(String? fullName) {
  RegExp nameRegex = RegExp(r'^[A-Za-z ]+$');

  if (fullName!.trim().isEmpty) {
    return 'Enter a full name';
  }
  if (!nameRegex.hasMatch(fullName)) {
    return 'Please enter a valid full name';
  }
  return null;
}

String? validateEmail(String? email) {
  RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  if (email!.trim().isEmpty) {
    return 'Enter an email';
  }
  if (!emailRegex.hasMatch(email)) {
    return 'Please enter a valid email';
  }
  return null;
}

String? validateRegNumber(String? regNumber) {
  RegExp regNumberRegex = RegExp(r'^[|A-Za-z0-9/]+$');

  if (regNumber!.trim().isEmpty) {
    return 'Enter a registration number';
  }
  if (!regNumberRegex.hasMatch(regNumber)) {
    return 'Please enter a valid registration number';
  }
  return null;
}

String? validatePassword(String? password) {
  RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{7,15}$',
  );

  if (password!.trim().isEmpty) {
    return 'Enter a password';
  }
  if (!passwordRegex.hasMatch(password)) {
    return 'Please enter a valid password.\n'
        '• Must have at least one uppercase letter \n'
        '• Must have at least one digit \n'
        '• Must have a speacial character [@#!&*] \n'
        '• Must be between 7 and 15 characters \n';
  }
  return null;
}
