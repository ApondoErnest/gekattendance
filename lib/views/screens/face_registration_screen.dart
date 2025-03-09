import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gekattendance/api/config.dart';
import 'package:gekattendance/api/user.dart';
import 'package:gekattendance/models/user.dart';
import 'package:gekattendance/providers/user_provider.dart';
import 'package:gekattendance/utils/common.dart';
import 'package:gekattendance/widgets/common/header.dart';
import 'package:gekattendance/widgets/common/navigation_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FaceRegistrationPage extends StatefulWidget {
  @override
  _FaceRegistrationPageState createState() => _FaceRegistrationPageState();
}

class _FaceRegistrationPageState extends State<FaceRegistrationPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _frontalImage;
  XFile? _leftSideImage;
  XFile? _rightSideImage;
  bool _isLoading = false;
  String _frontalFaceError = "";
  String _leftFaceError = "";
  String _rightFaceError = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showImageSourceDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Image Source"),
          actions: <Widget>[
            TextButton(
              child: const Text("Gallery"),
              onPressed: () {
                Navigator.of(context).pop();
                _pickOrTakeImage(type, ImageSource.gallery);
              },
            ),
            TextButton(
              child: const Text("Camera"),
              onPressed: () {
                Navigator.of(context).pop();
                _pickOrTakeImage(type, ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickOrTakeImage(String type, ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() => _isLoading = true);

      try {
        Token? token = await uploadStudentFace(image, type);
        if (context.mounted) {
          saveUserTokenAndUpdateUser(context, token!);
          UserProvider userProvider =
              Provider.of<UserProvider>(context, listen: false);
          Map<String, String> faceMap = {
            "frontal": "front_face",
            "left": "left_face",
            "right": "right_face",
          };
          XFile? file = await urlToXFile(
              mediaUrl(userProvider.user!.student![faceMap[type]]));
          setState(() {
            if (type == "frontal") {
              _frontalFaceError = "";
              _frontalImage = file;
            } else if (type == "left") {
              _leftFaceError = "";
              _leftSideImage = file;
            } else if (type == "right") {
              _rightFaceError = "";
              _rightSideImage = file;
            }
          });
        }
      } catch (error) {
        setState(() {
          if (type == "frontal") {
            _frontalFaceError = error.toString();
          } else if (type == "left") {
            _leftFaceError = error.toString();
          } else if (type == "right") {
            _rightFaceError = error.toString();
          }
        });
      } finally {
        setState(() => _isLoading = false);
      }
    }
    setState(() => _isLoading = false);
  }

  Widget _buildImageSection(
      {required String title,
      required String examplePath,
      required XFile? imageFile,
      required VoidCallback onUpload,
      required String faceDirection}) {
    Map<String, String> faceErrorMap = {
      "frontal": _frontalFaceError,
      "left": _leftFaceError,
      "right": _rightFaceError
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Image.asset(
                  examplePath,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                Text("Example",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            SizedBox(width: 16),
            imageFile != null
                ? Image.file(
                    File(imageFile.path),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                  ),
          ],
        ),
        SizedBox(height: 10),
        if (faceErrorMap[faceDirection]!.isNotEmpty)
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  faceErrorMap[faceDirection] ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.redAccent),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        imageFile == null
            ? Center(
                child: ElevatedButton(
                  onPressed: onUpload,
                  child: Text("Upload Image"),
                ),
              )
            : Container(),
        Divider(),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(onMenuTap: () {}),
      drawer: const CustomNavigationDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Upload images of your face following the examples\nEnsure you are in natural and bright environment',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 20),
                _buildImageSection(
                    title: "Frontal Image",
                    examplePath: "assets/images/frontal-view.png",
                    imageFile: _frontalImage,
                    onUpload: () => _showImageSourceDialog("frontal"),
                    faceDirection: 'frontal'),
                _buildImageSection(
                    title: "Left Side View (Yaw 10°-45°)",
                    examplePath: "assets/images/left-turn-view.png",
                    imageFile: _leftSideImage,
                    onUpload: () => _showImageSourceDialog("left"),
                    faceDirection: 'left'),
                _buildImageSection(
                    title: "Right Side View (Yaw 10°-45°)",
                    examplePath: "assets/images/right-turn-view.png",
                    imageFile: _rightSideImage,
                    onUpload: () => _showImageSourceDialog("right"),
                    faceDirection: 'right'),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
