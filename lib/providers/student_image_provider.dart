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

class StudentImageProvider extends ChangeNotifier {
  bool isLoading = false;

  File? studImage;
  String studRegNo = '';

  void resetStudImage() {
    studImage = null;
    notifyListeners();
  }

  void _detectFace(File imageFile) async {
    final faces = await faceDetector.processImage(
      InputImage.fromFile(imageFile),
    );

    if (faces.length != 1) {
      //TODO: handle this exception on the UI
      throw ManyOrNoFacesException();
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
    } on ManyOrNoFacesException {
      isLoading = false;
      notifyListeners();
      rethrow;
    } on IncorrectHeadPositionException {
      isLoading = false;
      notifyListeners();
      rethrow;
    } on DimEnvironmentException {
      isLoading = false;
      notifyListeners();
      rethrow;
    } catch (error) {
      isLoading = false;
      notifyListeners();
      throw NoImageSelectedException();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> takePicture(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final File imageFile = (await Navigator.of(context)
          .pushNamed(AppRouter.takePictureRoute))! as File;
      _detectFace(imageFile);
      if (!context.mounted) return;
    } on ManyOrNoFacesException {
      isLoading = false;
      notifyListeners();
      rethrow;
    } on IncorrectHeadPositionException {
      isLoading = false;
      notifyListeners();
      rethrow;
    } on DimEnvironmentException {
      isLoading = false;
      notifyListeners();
      rethrow;
    } catch (error) {
      print(error);
      isLoading = false;
      notifyListeners();
      throw NoPhotoCapturedException();
    }

    isLoading = false;
    notifyListeners();
  }
}
