import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Container());
  }
}

class _horizontalGap extends StatelessWidget {
  const _horizontalGap({super.key, required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size);
  }
}

class _verticalGap extends StatelessWidget {
  final double size;
  const _verticalGap({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size);
  }
}
