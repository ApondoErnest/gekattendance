import 'package:flutter/material.dart';
import 'package:gekattendance/api/user.dart';
import 'package:gekattendance/widgets/common/fill_button.dart';
import 'package:gekattendance/widgets/common/input.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  String _error = "";
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _error = "";
  }

  Future<void> _onLoginPressed() async {
    setState(() {
      _isLoading = true;
      _error = "";
    });

    final String email = _emailController.text;

    try {
      await loginGenerateOtp(email);
      if (context.mounted) {
        Navigator.pushNamed(context, '/auth/login/complete', arguments: email);
      }
    } catch (error) {
      print('######## error $error');
      setState(() {
        _error = (error as Map<String, dynamic>)['message'];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(100), // Makes it circular
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/ub-logo.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Welcome Back",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  _error.isNotEmpty
                      ? Column(
                          children: [
                            Text(
                              _error,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Color(0XFFD32F2F)),
                            ),
                            SizedBox(height: 20),
                          ],
                        )
                      : Container(),
                  MyTextInput(
                    label: 'Email',
                    textEditingController: _emailController,
                  ),
                  const SizedBox(height: 20),
                  MyFillButton(
                    'Login',
                    height: 40,
                    width: double.infinity,
                    onPressed: _isLoading
                        ? () {}
                        : _onLoginPressed, // Disable button while loading
                  ),
                ],
              ),
            ),
          ),
          // Show loading overlay when _isLoading is true
          if (_isLoading)
            Container(
              color:
                  Colors.black.withOpacity(0.4), // Semi-transparent background
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
