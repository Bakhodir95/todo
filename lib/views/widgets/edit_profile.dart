import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo/controllers/user_controller.dart';
import 'package:todo/models/user.dart';

class EditProfile extends StatefulWidget {
  final User user;
  final VoidCallback onSave;
  final UserController userController;

  EditProfile({super.key, required this.user, required this.onSave, required this.userController});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController phoneNumberController;
  late TextEditingController imageUriController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    surnameController = TextEditingController(text: widget.user.surname);
    phoneNumberController = TextEditingController(text: widget.user.phoneNumber);
    imageUriController = TextEditingController(text: widget.user.imageUri);
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneNumberController.dispose();
    imageUriController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        top: 10,
        left: 10,
        right: 10,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "name"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ism Kriting";
                  }
                  return null;
                },
              ),
              const Gap(10),
              TextFormField(
                controller: surnameController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "surname"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Familya Kriting";
                  }
                  return null;
                },
              ),
              const Gap(10),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "phoneNumber"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "ramingizni Kriting";
                  }
                  return null;
                },
              ),
              const Gap(10),
              TextFormField(
                controller: imageUriController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "image uri"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "rasm uri ni Kriting";
                  }
                  return null;
                },
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  const Gap(25),
                  FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        widget.user.name = nameController.text;
                        widget.user.surname = surnameController.text;
                        widget.user.phoneNumber = phoneNumberController.text;
                        widget.user.imageUri = imageUriController.text;
                        await widget.userController.saveUser(widget.user);
                        widget.onSave();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
