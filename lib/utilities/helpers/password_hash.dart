import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  // Use SHA-256 for hashing
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

bool comparePasswords(String hashedPassword, String enteredPassword) =>
    hashedPassword == hashPassword(enteredPassword);
