import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo/services/check_user_serves.dart';
import 'package:todo/views/screens/login_vs_register/register_page.dart';
import 'package:todo/views/screens/maneger_page.dart'; // Fixed typo in ManagerPage import

class LoginScreen extends StatefulWidget {
  Function() mainSetState;
  LoginScreen({super.key, required this.mainSetState});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String errorEmail = "";
  bool isLoading = false;
  CheckUserServes checkUserServes = CheckUserServes();

  final formkey = GlobalKey<FormState>();
  bool isPasswordVisibility = true; // Fixed typo in variable name
  String logindata = "";
  String passworddata = "";

  saveLogin() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorEmail = ""; // Reset error message
      });
      formkey.currentState!.save();
      final response = await checkUserServes.register(logindata, passworddata, "signInWithPassword");

      setState(() {
        isLoading = false;
      });

      if (response.containsKey('idToken')) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ManagerPage(
                mainSetState: widget.mainSetState,
              ),
            ));
      } else {
        setState(() {
          errorEmail = response['message'] ?? 'An error occurred. Please try again.'; // Improved error handling
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
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (errorEmail.isNotEmpty)
                  Text(
                    errorEmail,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16.0),
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
                    logindata = value!;
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
                    passworddata = value!;
                  },
                ),
                const Gap(10),
                InkWell(
                  onTap: isLoading ? null : saveLogin, // Disable button while loading
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Log in",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(
                          mainSetState: widget.mainSetState,
                        ),
                      ),
                    );
                  },
                  child: const Text("Create account"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
