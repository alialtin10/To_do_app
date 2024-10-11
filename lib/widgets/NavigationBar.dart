import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/pages/calendar_page.dart';
import 'package:to_do_app/pages/todoDay_page.dart';
import 'package:to_do_app/pages/study_page.dart';

class Navigationbar extends StatefulWidget {
  const Navigationbar({super.key});

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  int currentPageIndex = 0;
  // Sayfaları tutan bir liste
  final List<Widget> _pages = [
    TododayPage(),       // Günlük sayfası
    CalendarPage(),  // Takvim sayfası
    StudyPage(),     // Çalışma sayfası
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: _pages,
      ),
      bottomNavigationBar:  NavigationBar(
      
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
          
        },
        destinations:  <Widget> [
          NavigationDestination(icon: const Icon(Icons.ballot_outlined), label: "navigation_day_label".tr()),
          NavigationDestination(icon: const Icon(Icons.calendar_month_outlined), label: "navigation_calender_label".tr()),
          NavigationDestination(icon: const Icon((Icons.bookmark_border)), label: "navigation_study_label".tr()),
        ]),
    );
  }
}