import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gekattendance/api/user.dart';
import 'package:gekattendance/models/user.dart';
import 'package:gekattendance/utils/common.dart';
import 'package:gekattendance/widgets/common/fill_button.dart';

class LoginCompletePage extends StatefulWidget {
  final String email;

  const LoginCompletePage({super.key, required this.email});

  @override
  State<LoginCompletePage> createState() => _LoginCompletePageState();
}

class _LoginCompletePageState extends State<LoginCompletePage> {
  int position = 0;
  final List<String> keys = List.filled(6, '');
  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _controllers;
  bool isAuthConfirmProgress = false;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (_) => FocusNode());
    _controllers = List.generate(6, (_) => TextEditingController());
    for (TextEditingController controller in _controllers) {
      controller.addListener(_handleKeyChange);
    }
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() => _handleFocusChange(i));
    }
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (TextEditingController controller in _controllers) {
      controller.removeListener(_handleKeyChange);
      controller.dispose();
    }
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].removeListener(() => _handleFocusChange(i));
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  void _handleKeyChange() {
    final newText = _controllers[position].text;
    if (keys[position] != newText) {
      setState(() {
        keys[position] = newText;
      });
      if (newText.isNotEmpty && position < 5) {
        _focusNodes[position + 1].requestFocus();
      }
    }
  }

  void _handleFocusChange(int position) {
    this.position = position;
  }

  void _onConfirmAuth(BuildContext context) async {
    setState(() => isAuthConfirmProgress = true);
    Token? authToken = await loginConfirmOtp(widget.email, keys.join(''));
    if (mounted) {
      _loginUser(context, authToken);
    }
  }

  void _loginUser(BuildContext context, Token? token) {
    User user = saveUserTokenAndUpdateUser(context, token!);
    setState(() => isAuthConfirmProgress = false);
    Navigator.pushReplacementNamed(context, determineStartRoute(user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (KeyEvent event) {
                  if (event.logicalKey == LogicalKeyboardKey.backspace &&
                      position > 0 &&
                      event is KeyUpEvent) {
                    if (keys[position].isEmpty) {
                      position--;
                    }
                    _controllers[position].text = "";
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset("assets/images/ub-logo.jpeg",
                            width: 100, height: 100, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Enter the code that has been sent to ${widget.email}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            List.generate(6, (index) => _buildCodeInput(index)),
                      ),
                      const SizedBox(height: 40),
                      MyFillButton(
                        'Confirm',
                        width: double.infinity,
                        height: 42,
                        onPressed: isAuthConfirmProgress
                            ? () {}
                            : () => _onConfirmAuth(context),
                        isDisabled: isAuthConfirmProgress,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isAuthConfirmProgress)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCodeInput(int index) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          counterText: '',
          border: UnderlineInputBorder(),
        ),
        showCursor: false,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
