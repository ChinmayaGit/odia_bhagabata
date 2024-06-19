import 'package:flutter/material.dart';
import 'package:odia_bhagabata/global.dart';


class ChapterPage extends StatelessWidget {
  final Chapter chapter;
  final Function(Section) navigateToSection;

  ChapterPage({required this.chapter, required this.navigateToSection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.title),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: chapter.sections.length,
        itemBuilder: (context, index) {
          Section section = chapter.sections[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDarkMode == true ? Colors.white : Colors.black,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: ListTile(
                title: Text(section.title),
                onTap: () => navigateToSection(section),
              ),
            ),
          );
        },
      ),
    );
  }
}