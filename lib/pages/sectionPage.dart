import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:odia_bhagabata/global.dart';

class SectionPage extends StatefulWidget {
  final Section section;

  SectionPage({required this.section});

  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  double localZoom = globalZoom;
  final FlutterTts flutterTts = FlutterTts();

  bool isVoiceReady = false;
  bool isSpeaking = false;

  double speechRate = 0.4;

  List<String> chunks = [];
  int currentChunkIndex = 0;

  @override
  void initState() {
    super.initState();
    checkAndDownloadVoice();
  }

  Future<void> checkAndDownloadVoice() async {
    while (!isVoiceReady) {
      List<dynamic> languages = await flutterTts.getLanguages;
      if (languages.contains('or-IN')) {
        await flutterTts.setLanguage('or-IN');
        isVoiceReady = true;
        if (mounted) setState(() {});
        break;
      } else {
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  void _showZoomBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Adjust Font Size',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Zoom: ${globalZoom.toStringAsFixed(1)}x',
                    style: TextStyle(fontSize: 16),
                  ),
                  Slider(
                    min: 0.5,
                    max: 3.0,
                    value: globalZoom,
                    label: globalZoom.toStringAsFixed(1),
                    onChanged: (value) {
                      setModalState(() {
                        globalZoom = value;
                      });
                      setState(() {
                        // Rebuild SectionPage with new zoom
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showTTSController() async {
    if (!isVoiceReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Odia TTS voice not ready yet. Please wait...')),
      );
      return;
    }

    chunks = widget.section.content
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
    currentChunkIndex = 0;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          Future<void> speakChunks() async {
            isSpeaking = true;
            if (Navigator.of(context).canPop()) setModalState(() {});
            while (isSpeaking && currentChunkIndex < chunks.length) {
              final line = chunks[currentChunkIndex].trim();
              if (line.isNotEmpty) {
                await flutterTts.setSpeechRate(speechRate);
                await flutterTts.speak(line);
                await Future.delayed(const Duration(seconds: 3));
              }
              currentChunkIndex++;
              if (!mounted || !Navigator.of(context).canPop()) return;
              setModalState(() {});
            }
            isSpeaking = false;
            if (Navigator.of(context).canPop()) setModalState(() {});
          }

          Future<void> stopSpeaking() async {
            await flutterTts.stop();
            isSpeaking = false;
            if (Navigator.of(context).canPop()) setModalState(() {});
          }

          Future<void> pauseSpeaking() async {
            await flutterTts.stop();
            isSpeaking = false;
            if (Navigator.of(context).canPop()) setModalState(() {});
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Audio Controls',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: isSpeaking ? null : speakChunks,
                      icon: Icon(Icons.play_arrow),
                      label: Text('Play'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: isSpeaking ? pauseSpeaking : null,
                      icon: Icon(Icons.pause),
                      label: Text('Pause'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        stopSpeaking();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.stop),
                      label: Text('Stop'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('Speech Rate: ${speechRate.toStringAsFixed(2)}'),
                Slider(
                  min: 0.2,
                  max: 1.0,
                  value: speechRate,
                  label: speechRate.toStringAsFixed(2),
                  onChanged: (value) {
                    speechRate = value;
                    if (Navigator.of(context).canPop()) setModalState(() {});
                  },
                ),
                SizedBox(height: 20),
                Text('Progress: ${currentChunkIndex + 1} / ${chunks.length}'),
                Slider(
                  min: 0,
                  max: (chunks.length - 1).toDouble(),
                  value: currentChunkIndex.toDouble(),
                  onChanged: (value) {
                    currentChunkIndex = value.toInt();
                    stopSpeaking();
                    if (Navigator.of(context).canPop()) setModalState(() {});
                  },
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    stopSpeaking();
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.section.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.zoom_in),
            onPressed: _showZoomBottomSheet,
          ),
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: _showTTSController,
          ),
        ],
      ),
      body: isVoiceReady
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.section.content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20 * globalZoom),
          ),
        ),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Downloading Odia TTS voice…\nPlease stay connected!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
