import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final String? title;
  final Widget body;
  final int currentIndex;
  final VoidCallback? onFabPressed;
  final bool loading;
  final bool showBottomNav;
  final PreferredSizeWidget? appBar;
  final IconData floatingActionButtonIcon;

  const AppLayout({
    super.key,
    this.title,
    required this.body,
    this.appBar,
    this.currentIndex = 0,
    this.onFabPressed,
    this.loading = false,
    this.showBottomNav = false,
    this.floatingActionButtonIcon = Icons.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBar ??
          AppBar(
            title: Text(
              title!,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: Colors.blueGrey[600],
              ),
            ),
          ),
      body: Stack(
        children: [
          body,
          if (loading)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      floatingActionButton: onFabPressed != null
          ? FloatingActionButton(
              onPressed: onFabPressed,
              child: Icon(floatingActionButtonIcon),
            )
          : null,
      bottomNavigationBar: showBottomNav
          ? BottomNavigationBar(
              currentIndex: currentIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_tennis),
                  label: "Games",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Settings",
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushReplacementNamed(context, '/');
                } else if (index == 1) {
                  Navigator.pushReplacementNamed(context, '/games');
                } else if (index == 2) {
                  // Use pushNamed for settings so user can go back
                  Navigator.pushNamed(context, '/user-settings');
                }
              },
            )
          : null,
    );
  }
}
