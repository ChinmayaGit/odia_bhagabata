import 'package:flutter/material.dart';
import 'package:odia_bhagabata/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _addCover = showCover; // 👈 initial value
  double _zoom = globalZoom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Cover :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Switch(
                  value: _addCover,
                  onChanged: (value) async {
                    setState(() {
                      _addCover = value;
                      showCover = value;
                    });

                    // ✅ Save cover toggle persistently
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool('showCover', showCover);
                  },
                ),

              ],
            ),
            SizedBox(height: 20),
            Text(
              'Zoom : ${_zoom.toStringAsFixed(1)}x',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              min: 0.5,
              max: 3.0,
              value: _zoom,
              onChanged: (value) {
                setState(() {
                  _zoom = value;
                  globalZoom = value;
                });
              },
            ),

          ],
        ),
      ),
    );
  }
}
