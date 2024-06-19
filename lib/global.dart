
import 'package:odia_bhagabata/book/section_01.dart';
import 'package:odia_bhagabata/book/section_02.dart';
import 'package:odia_bhagabata/book/section_03.dart';
import 'package:odia_bhagabata/book/section_04.dart';
import 'package:odia_bhagabata/book/section_05.dart';
import 'package:odia_bhagabata/book/section_06.dart';
import 'package:odia_bhagabata/book/section_07.dart';
import 'package:odia_bhagabata/book/section_08.dart';
import 'package:odia_bhagabata/book/section_09.dart';
import 'package:odia_bhagabata/book/section_10.dart';
import 'package:odia_bhagabata/book/section_11.dart';
import 'package:odia_bhagabata/book/section_12.dart';
import 'package:odia_bhagabata/book/section_13.dart';

bool isDarkMode = true;

class Section {
  final String title;
  final String content;
  bool isRead;
  Section({required this.title,this.isRead = false, required this.content});
}

class Chapter {
  final String title;
  bool isRead;
  final List<Section> sections;

  Chapter({required this.title,this.isRead = false, required this.sections});
}

List<Chapter> chapters = [
  Chapter(title: 'ପ୍ରଥମ ସ୍କନ୍ଧ || ୧', sections: section1,),
  Chapter(title: 'ଦ୍ଵିତୀୟ ସ୍କନ୍ଧ || ୨', sections: section2,),
  Chapter(title: 'ତୃତୀୟ ସ୍କନ୍ଧ || ୩', sections: section3),
  Chapter(title: 'ଦଚତୁର୍ଥ ସ୍କନ୍ଧ || ୪', sections: section4),
  Chapter(title: 'ପଞ୍ଚମ ସ୍କନ୍ଧ || ୫', sections: section5),
  Chapter(title: 'ଷଷ୍ଠ ସ୍କନ୍ଧ || ୬', sections: section6),
  Chapter(title: 'ସପ୍ତମ ସ୍କନ୍ଧ || ୭', sections: section7),
  Chapter(title: 'ଅଷ୍ଟମ ସ୍କନ୍ଧ || ୮', sections: section8),
  Chapter(title: 'ନବମ ସ୍କନ୍ଧ || ୯', sections: section9),
  Chapter(title: 'ଦଦଶମ ସ୍କନ୍ଧ || ୧୦', sections: section10),
  Chapter(title: 'ଦଏକାଦଶ ସ୍କନ୍ଧ || ୧୧', sections: section11),
  Chapter(title: 'ଦ୍ଵାଦଶ ସ୍କନ୍ଧ || ୧୨', sections: section12),
  Chapter(title: 'ତ୍ରୟୋଦଶ ସ୍କନ୍ଧ || ୧୩', sections: section13),
];
