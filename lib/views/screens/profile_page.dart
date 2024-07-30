import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/controllers/user_controller.dart';
import 'package:todo/views/widgets/edit_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserController userController = UserController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    await userController.getUser();
    setState(() {
      isLoading = false;
    });
  }

  void refreshProfile() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          AppBar(
            title: Text(AppLocalizations.of(context)!.profilepage),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => EditProfile(
                      user: userController.user,
                      onSave: refreshProfile,
                      userController: userController,
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      backgroundImage: NetworkImage(
                        userController.user.imageUri ?? "https://static.vecteezy.com/system/resources/thumbnails/019/900/306/small/happy-young-cute-illustration-face-profile-png.png",
                      ),
                      radius: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${AppLocalizations.of(context)!.name}: ${userController.user.name}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${AppLocalizations.of(context)!.surname}: ${userController.user.surname}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${AppLocalizations.of(context)!.number}: ${userController.user.phoneNumber}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
