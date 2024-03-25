import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Preview'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 40.0),
          child: Center(
            child: Placeholder(),
            // Consumer<StudentImageProvider>(
            //   builder: (_, imgProvider, __) {
            //     if (imgProvider.isLoading) {
            //       return const CircularProgressIndicator();
            //     } else {
            //       return Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           CircleAvatar(
            //             backgroundColor:
            //                 Theme.of(context).colorScheme.secondary,
            //             backgroundImage: imgProvider.studImage == null
            //                 ? null
            //                 : FileImage(imgProvider.studImage!),
            //             radius: 120,
            //             child: imgProvider.studImage == null
            //                 ? const Icon(
            //                     Icons.person,
            //                     size: 70,
            //                     color: Colors.white,
            //                   )
            //                 : null,
            //           ),
            //           const SizedBox(height: 40),
            //           imgProvider.isLoading
            //               ? const CircularProgressIndicator()
            //               : Column(
            //                   children: [
            //                     imgProvider.studImage == null
            //                         ? const SizedBox()
            //                         : const Text('Not loading state'),
            //                         // SizedBox(
            //                         //     width: context.size!.width * .9,
            //                         //     child: 
            //                         //     CustomFormField(

                                          
            //                         //       initialValue: imgController.studRegNo,
            //                         //       keyboardType: TextInputType.text,
            //                         //       labelText: 'Student Reg No',
            //                         //       prefixIconData:
            //                         //           Icons.app_registration_rounded,
            //                         //       onChanged: imgController.studRegNo,
            //                         //       validator: (value) =>
            //                         //           validateRegNumber(
            //                         //               value, 'Registration Number'), 
                                                  
            //                         //       controller: null, 
            //                         //       prefixIcon: null,
            //                         //     ),
            //                         //   ),
            //                     const SizedBox(height: 20),
            //                     imgProvider.studImage == null
            //                         ? const SizedBox()
            //                         : SizedBox(
            //                             width: context.size!.width * .7,
            //                             child: ElevatedButton(
            //                               onPressed: () async =>
            //                                   await imgProvider.submitImage(),
            //                               style: ButtonStyle(
            //                                 backgroundColor:
            //                                     MaterialStateProperty.all(
            //                                         Colors.blueGrey[700]),
            //                               ),
            //                               child: const Text('Submit Image'),
            //                             ),
            //                           ),
            //                     const SizedBox(height: 20),
            //                     SizedBox(
            //                       width: context.size!.width * .7,
            //                       child: ElevatedButton(
            //                         onPressed: () async => await imgProvider.takePicture(context),
            //                         child: const Text('Take picture'),
            //                       ),
            //                     ),
            //                     const SizedBox(height: 20),
            //                     SizedBox(
            //                       width: context.size!.width * .7,
            //                       child: ElevatedButton(
            //                         onPressed: () async =>
            //                             await imgProvider.getImageFromGallery(),
            //                         child: const Text('Upload photo'),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //         ],
            //       );
            //     }
            //   },
            // ),
          ),
        ),
      ),
    );
  }
}

//* The GetX Controller for image preview

// class ImageController extends GetxController {
//   RxBool isLoading = RxBool(false);
//   Rx<File?> studImage = Rx(null);
//   Rx<String> studRegNo = Rx('');


//   Future<void> submitImage() async {
//     isLoading(true);

//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse(Endpoints.submitStudentPhoto),
//       )..fields['regNo'] = studRegNo.value;
//       var stream = http.ByteStream(studImage.value!.openRead());
//       var length = await studImage.value!.length();

//       var multipartFile = http.MultipartFile(
//         'student_image',
//         stream,
//         length,
//         filename: studImage.value!.path.split('/').last,
//       );
//       request.files.add(multipartFile);

//       var response = await request.send();
//       // var responseBody = json.decode(await response.stream.bytesToString());

//       if (response.statusCode == 200) {
//         showSnack(
//           'Success',
//           'Student photo successfully',
//           Colors.green[400]!,
//           Icons.error_rounded,
//           1,
//         );
//       } else {
//         print(response.statusCode);
//         showSnack(
//           'Error',
//           'Something went wrong',
//           Colors.orange[400]!,
//           Icons.error_rounded,
//           1,
//         );
//       }
//     } catch (error) {
//       showSnack(
//         'Error',
//         'Please check your internet connection',
//         Colors.red[400]!,
//         Icons.error_rounded,
//         1,
//       );
//     }

//     isLoading(false);
//   }
// }
