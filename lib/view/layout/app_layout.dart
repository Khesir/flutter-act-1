import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final String? title;
  final Widget body;
  final int currentIndex;
  final VoidCallback? onFabPressed;
  final bool loading;
  final bool showBottomNav;
  final PreferredSizeWidget? appBar;

  const AppLayout({
    super.key,
    this.title,
    required this.body,
    this.appBar,
    this.currentIndex = 0,
    this.onFabPressed,
    this.loading = false,
    this.showBottomNav = false,
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
              child: const Icon(Icons.refresh),
            )
          : null,
      bottomNavigationBar: showBottomNav
          ? BottomNavigationBar(
              currentIndex: currentIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Form"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check),
                  label: "Summary",
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushReplacementNamed(context, '/');
                } else if (index == 1) {
                  Navigator.pushReplacementNamed(context, '/form');
                } else if (index == 2) {
                  Navigator.pushReplacementNamed(context, '/summary');
                }
              },
            )
          : null,
    );
  }
}
