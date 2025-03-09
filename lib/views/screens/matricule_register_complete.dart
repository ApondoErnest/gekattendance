import 'package:flutter/material.dart';
import 'package:gekattendance/api/user.dart';
import 'package:gekattendance/models/user.dart';
import 'package:gekattendance/utils/common.dart';
import 'package:gekattendance/widgets/common/header.dart';
import 'package:gekattendance/widgets/common/input.dart';

class MatriculeRegisterCompletePage extends StatefulWidget {
  MatriculeRegisterCompletePage({super.key});

  @override
  State<MatriculeRegisterCompletePage> createState() =>
      _MatriculeRegisterCompleteState();
}

class _MatriculeRegisterCompleteState
    extends State<MatriculeRegisterCompletePage> {
  final TextEditingController _textEditingController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _saveMatricule() async {
    String matricule = _textEditingController.text;
    if (matricule.isEmpty) {
      setState(() {
        _errorMessage = 'Matricule is required.';
      });
    } else {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      try {
        Token? token = await updateStudentMatricule(matricule);
        saveUserTokenAndUpdateUser(context, token!);
        Navigator.pushNamed(context, '/student/register/face');
      } catch (error) {
        setState(() {
          _errorMessage = error.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(onMenuTap: () {}),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _errorMessage.isNotEmpty
                    ? Text(
                        _errorMessage,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.redAccent),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: MyTextInput(
                      label: 'Matricule',
                      textEditingController: _textEditingController),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveMatricule,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Next",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_right, size: 28),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
