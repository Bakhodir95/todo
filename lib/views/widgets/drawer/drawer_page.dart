import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const Gap(15),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settings),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/admin');
            },
            leading: const Icon(Icons.admin_panel_settings),
            title: Text(AppLocalizations.of(context)!.adminpanel),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
          )
        ],
      ),
    );
  }
}
