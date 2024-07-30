import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo/services/check_user_serves.dart';
import 'package:todo/views/screens/login_vs_register/login_page.dart';

class RegisterPage extends StatefulWidget {
  Function() mainSetState;
  RegisterPage({super.key, required this.mainSetState});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  CheckUserServes checkUserServes = CheckUserServes();
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisibility = true;
  String emailData = "";
  String passwordData = "";
  String passwordData2 = "";
  String errorMessage = "";

  saveRegister() async {
    if (formKey.currentState!.validate()) {
      if (passwordData != passwordData2) {
        setState(() {
          errorMessage = "Passwords do not match";
        });
        return;
      }

      formKey.currentState!.save();
      setState(() {
        isLoading = true;
        errorMessage = "";
      });

      final response = await checkUserServes.register(emailData, passwordData, "signUp");

      setState(() {
        isLoading = false;
      });

      if (response.containsKey('idToken')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              mainSetState: widget.mainSetState,
            ),
          ),
        );
      } else {
        setState(() {
          errorMessage = response['message'] ?? 'Registration failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade800,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: const TextStyle(fontSize: 15, color: Colors.red),
                  ),
                const Gap(15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    helperText: "Example: example@gmail.com",
                    helperStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Invalid email entered";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    emailData = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  obscureText: isPasswordVisibility,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisibility = !isPasswordVisibility;
                        });
                      },
                      icon: Icon(
                        isPasswordVisibility ? CupertinoIcons.eye_slash : CupertinoIcons.eye_fill,
                        color: Colors.white,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    helperText: "Example: password",
                    helperStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Invalid password entered";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    passwordData = value!;
                  },
                ),
                const Gap(10),
                TextFormField(
                  obscureText: isPasswordVisibility,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    helperText: "Example: password confirm",
                    helperStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Invalid password entered";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    passwordData2 = value!;
                  },
                ),
                const Gap(5),
                InkWell(
                  onTap: isLoading ? null : saveRegister,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Create account",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
