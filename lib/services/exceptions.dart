// Auth Exceptions
class GenericException implements Exception {
  @override
  String toString() {
    return 'Something went wrong';
  }
}

class UserNotFoundException implements Exception {
  const UserNotFoundException({this.identifier});

  final String? identifier;

  @override
  String toString() {
    return 'User with the specified $identifier not found';
  }
}

class InvalidRoleException implements Exception {
  @override
  String toString() {
    return 'Ensure you have logged in with the correct role';
  }
}

class IdentifierPasswordMismatchException implements Exception {
  @override
  String toString() {
    return 'Incorrect password entered';
  }
}

class EmailAlreadyInUseException implements Exception {
  @override
  String toString() {
    return 'User with a similar email exists';
  }
}

class RegNoAlreadyInUseException implements Exception {
  @override
  String toString() {
    return 'User with a similar registration number exists';
  }
}

class LocationNotFoundException implements Exception {
  @override
  String toString() {
    return 'Location with that name does not exist';
  }
}

class CourseNotFoundException implements Exception {
  @override
  String toString() {
    return 'Course with that name does not exist';
  }
}

class ManyOrNoFacesException implements Exception {
  @override
  String toString() {
    return 'Image should contain a single face';
  }
}

class DimEnvironmentException implements Exception {
  @override
  String toString() {
    return 'Please move to a location with more light';
  }
}

class IncorrectHeadPositionException implements Exception {
  @override
  String toString() {
    return 'Incorrect head position';
  }
}

class NoImageSelectedException implements Exception {
  @override
  String toString() {
    return 'No image selected from the gallery';
  }
}

class NoPhotoCapturedException implements Exception {
  @override
  String toString() {
    return 'No photo captured with your camera';
  }
}