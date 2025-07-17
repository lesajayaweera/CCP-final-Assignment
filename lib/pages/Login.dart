// import 'package:flutter/material.dart';

// class Login extends StatefulWidget {
//   final VoidCallback login;
//   Login({super.key, required this.login}){}


//   @override
//   _LoginState createState() => _LoginState();
// }

// class _LoginState extends State<Login> {

//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(color: Colors.blue),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 40),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Login',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 40,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Welcome Back',
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//               Center(
//                 child: Card(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                       ),
//                     ),
//                     child: Form(
//                       key:_formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           _verticalGap(size: 60),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: _CustomTextForm(label: 'Email', controller: emailController, icon: Icons.email),
//                           ),
//                            _verticalGap(size: 10),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: _CustomTextForm(label: 'Password', controller: passwordController, icon: Icons.password,isPassword: true,),
//                           )
                      
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _horizontalGap extends StatelessWidget {
//   const _horizontalGap({super.key, required this.size});
//   final double size;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(width: size);
//   }
// }

// class _verticalGap extends StatelessWidget {
//   final double size;
//   const _verticalGap({super.key, required this.size});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(height: size);
//   }
// }


// class _CustomTextForm extends StatelessWidget {
//   final String label;
//   final IconData ?icon;
//   final TextEditingController controller;
//   final bool isPassword;
//   final String? Function(String?)? validator;


//   const _CustomTextForm({super.key,required this.label,required this.controller, required this.icon,this.isPassword=false, this.validator});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       validator:validator,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         labelText: label,prefixIcon: icon !=null ? Icon(icon) :null,
//         border: OutlineInputBorder(),
//         filled:  true,
//         fillColor: Colors.white,
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 2),
//         ),
//       ),

//     );
//   }
// }

import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sports, size: 48, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      "Welcome to SportIgnite",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Login to ignite your sporting journey!",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailValid = RegExp(
                          r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                        ).hasMatch(value);
                        if (!emailValid) return 'Enter a valid email address';
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'example@email.com',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Remember Me + Forgot
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _rememberMe = value);
                          },
                        ),
                        const Text('Remember me'),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // TODO: Add forgot password logic
                          },
                          child: const Text("Forgot Password?"),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // TODO: Add login logic
                          }
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // OR Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "OR",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Google Sign In Button (UI only)
                    SizedBox(
                      
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton.icon(
                          icon: Image.asset(
                            'asset/image/google.png', // Ensure this asset exists
                            height: 24,
                            width: 24,
                          ),
                          label: const Text(
                            "Continue with Google",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            foregroundColor: Colors.black87,
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            // TODO: Add Google Sign-In logic
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Signup Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to Register screen
                          },
                          child: const Text("Register Now"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
