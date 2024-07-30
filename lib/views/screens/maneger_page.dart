import 'package:flutter/material.dart';
import 'package:todo/views/screens/home_page.dart';
import 'package:todo/views/screens/profile_page.dart';
import 'package:todo/views/screens/statistics_page.dart';
import 'package:todo/views/widgets/drawer/drawer_page.dart';

class ManagerPage extends StatefulWidget {
  Function() mainSetState;
  ManagerPage({super.key, required this.mainSetState});

  @override
  State<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> with TickerProviderStateMixin {
  int currentIndex = 0;

  late List<Widget> pages;
  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(
        mainSetState: widget.mainSetState,
      ),
      const StatisticsPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerPage(),
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height / 11,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(icon: Icons.home, index: 0, label: "Home"),
            _buildNavItem(icon: Icons.bar_chart_outlined, index: 1, label: "Statistics"),
            _buildNavItem(icon: Icons.person, index: 2, label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index, required String label}) {
    return Expanded(
      child: IconButton(
        style: IconButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        onPressed: () {
          setState(() {
            currentIndex = index;
          });
        },
        icon: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 25,
              color: currentIndex == index ? Colors.deepPurpleAccent : Colors.grey,
            ),
            if (currentIndex == index)
              Text(
                label,
                style: const TextStyle(color: Colors.deepPurpleAccent),
              ),
          ],
        ),
      ),
    );
  }
}
