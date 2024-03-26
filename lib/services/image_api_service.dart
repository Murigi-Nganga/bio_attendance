import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageAPIService {
  final _endpoints = {
    "upload-image": "https://jeykey.pythonanywhere.com/upload_image",
    "comapre-encodings": "https://jeykey.pythonanywhere.com/compare_encodings",
  };

  // The endpoints allow you to:
  // 1. upload-image --> Get facial encodings for an image with a face
  // 2. compare-encodings --> Compare facial encodings of aan existing and mew images

  ImageAPIService();

  Future<Map<String, dynamic>> uploadImage(File studImage) async {
    Map<String, dynamic> result = {};

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(_endpoints["upload-image"]!),
      );

      var stream = http.ByteStream(studImage.openRead());
      var length = await studImage.length();

      var multipartFile = http.MultipartFile(
        'student_image',
        stream,
        length,
        filename: studImage.path.split('/').last,
      );
      request.files.add(multipartFile);

      var response = await request.send();
      var responseBody = json.decode(await response.stream.bytesToString())
          as Map<String, dynamic>;

      if (response.statusCode == 200) {
        result["success"] = true;
        result["message"] = "Student photo added successfully";
        result["encodings"] = responseBody["encodings"];
      } else {
        result["success"] = false;
        result["message"] = "Somethng went wrong";
      }
    } catch (error) {
      result["success"] = false;
      result["message"] = "Please check your internet connection";
    }
    return result;
  }
}
