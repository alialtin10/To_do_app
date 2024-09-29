import 'package:flutter/material.dart';
import 'package:to_do_app/widgets/NavigationBar.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: Navigationbar(),
      appBar: AppBar(title: Text('Çalışma Sayfa')),
      body: Center(child: Text('Çalışma sayfası')),
    );
  }
}