import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bio_attendance/router/app_router.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:bio_attendance/utilities/helpers/image_utils.dart';
import 'package:http/http.dart' as http;

class StudentImageProvider extends ChangeNotifier {
  bool isLoading = false;

  File? studImage;
  String studRegNo = '';

  final endpoints = {
    "upload-image": "https://jeykey.pythonanywhere.com/upload_image",
    "comapre-encodings": "https://jeykey.pythonanywhere.com/compare_encodings",
  };

  // The endpoints allow you to:
  // 1. upload-image --> Get facial encodings for an image with a face
  // 2. compare-encodings --> Compare facial encodings of aan existing and mew images

  void _detectFace(File imageFile) async {
    final faces = await faceDetector.processImage(
      InputImage.fromFile(imageFile),
    );

    if (faces.length != 1) {
      //TODO: handle this exception on the UI
      throw ManyFacesException();
    } else {
      final Uint8List bytes = await imageFile.readAsBytes();
      final Completer<ui.Image> completer = Completer();
      ui.decodeImageFromList(
          bytes, (ui.Image image) => completer.complete(image));
      final imageForBrightness = await completer.future;

      //* Brightness of the image
      double brightness = await calculateImageBrightness(imageForBrightness);

      if (brightness < 40) {
        throw DimEnvironmentException();
      }

      //? Head euler angles
      bool correctHeadPosition = faces[0].headEulerAngleX! < 15 &&
          faces[0].headEulerAngleX! > -15 &&
          faces[0].headEulerAngleY! < 20 &&
          faces[0].headEulerAngleY! > -20 &&
          !(faces[0].headEulerAngleX == 0 &&
              faces[0].headEulerAngleY == 0 &&
              faces[0].headEulerAngleZ == 0);

      if (correctHeadPosition) {
        studImage = imageFile;
        notifyListeners();
      } else {
        throw IncorrectHeadPositionException();
      }
    }
  }

  Future<void> getImageFromGallery() async {
    isLoading = true;
    notifyListeners();

    try {
      XFile? pickedXFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      _detectFace(File(pickedXFile!.path));
    } catch (error) {
      throw NoImageSelectedException();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> takePicture(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final File imageFile =
          (await Navigator.of(context).pushNamed(AppRouter.takePictureRoute))!;
      _detectFace(imageFile);
    } catch (error) {
      throw NoPhotoCapturedException();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> submitImage() async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> result = {};

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(endpoints["upload-image"]!),
      );

      //TODO: Send the image to the backend 

      var stream = http.ByteStream(studImage!.openRead());
      var length = await studImage!.length();

      var multipartFile = http.MultipartFile(
        'student_image',
        stream,
        length,
        filename: studImage!.path.split('/').last,
      );
      request.files.add(multipartFile);

      var response = await request.send();
      // var responseBody = json.decode(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        result["success"] = true;
        result["message"] = "Student photo added successfully";
      } else {
        result["success"] = false;
        result["message"] = "Somethng went wrong";
      }
    } catch (error) {
      result["success"] = false;
      result["message"] = "Please check your internet connection";
    }

    isLoading = false;
    notifyListeners();
    return result;
  }
}
