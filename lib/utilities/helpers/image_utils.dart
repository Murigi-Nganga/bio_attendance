import 'dart:ui' as ui;

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

final faceDetector = FaceDetector(
  options: FaceDetectorOptions(
    enableClassification: true,
    enableLandmarks: true,
    enableTracking: true,
    enableContours: true,
    minFaceSize: 0.7,
    performanceMode: FaceDetectorMode.accurate,
  ),
);

//? Calculate image brightness
Future<double> calculateImageBrightness(ui.Image image) async {
  // New image byte data buffer
  final buffer = await image.toByteData();

  double brightness = 0.0;

  for (var i = 0; i < buffer!.lengthInBytes; i += 4) {
    final r = buffer.getUint8(i);
    final g = buffer.getUint8(i + 1);
    final b = buffer.getUint8(i + 2);

    brightness += 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  //* Calculate the percentage brightness
  final maxBrightness = 255.0 * (buffer.lengthInBytes ~/ 4);
  final brightnessPercentage = (brightness / maxBrightness) * 100.0;

  return brightnessPercentage;
}