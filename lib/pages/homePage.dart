import 'package:flutter/material.dart';
import 'package:odia_bhagabata/global.dart';
import 'package:odia_bhagabata/pages/chapterPage.dart';
import 'package:odia_bhagabata/pages/sectionPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  HomePage({required this.toggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? lastSectionTitle;

  @override
  void initState() {
    super.initState();
    _loadLastSection();
  }

  _loadLastSection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastSectionTitle = prefs.getString('lastSectionTitle');
    });
  }

  _saveLastSection(String sectionTitle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastSectionTitle', sectionTitle);
  }

  _navigateToSection(Section section) {
    _saveLastSection(section.title);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SectionPage(section: section),
      ),
    );
  }

  _navigateToChapter(Chapter chapter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterPage(
            chapter: chapter, navigateToSection: _navigateToSection),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ଶ୍ରୀମଦ୍ଭାଗବତ"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: widget.toggleTheme,
            ),
          ],
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2, // Aspect ratio for the grid items
          ),
          padding: EdgeInsets.all(10),
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            Chapter chapter = chapters[index];
            return Card(
              elevation: 5,
              child: InkWell(
                onTap: () => _navigateToChapter(chapter),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'ଶ୍ରୀମଦ୍ଭାଗବତ',
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        chapter.title,
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: lastSectionTitle != null
            ? FloatingActionButton.extended(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? sectionTitle = prefs.getString('lastSectionTitle');
            Section? lastSection;
            for (var chapter in chapters) {
              for (var section in chapter.sections) {
                if (section.title == sectionTitle) {
                  lastSection = section;
                  break;
                }
              }
            }
            if (lastSection != null) {
              _navigateToSection(lastSection);
            }
          },
          label: Text("ପୂର୍ବରୁ"),
          icon: Icon(Icons.bookmark),
        )
            : Container()
    );
  }
}