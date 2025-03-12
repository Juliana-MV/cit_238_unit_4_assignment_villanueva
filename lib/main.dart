import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Picker & Toggle App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDarkMode = false;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadPreferences(); 
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode =
          prefs.getBool('darkMode') ?? false; 
    });
  }

  _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _isDarkMode); 
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    _savePreferences(); 
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Picker & Toggle App'),
      ),
      body: Container(
        color: _isDarkMode
            ? Colors.black
            : Colors.white, 
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              _imagePath == null
                  ? Text('No photo selected.', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),)
                  : Image.file(
                      File(_imagePath!),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
      
                child: const Text('Pick a Photo',
                      style: TextStyle(
                      color: Colors.black,
                    )),
              ),
              SizedBox(height: 20),
              // Toggle Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dark Mode', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),),
                  Switch(
                    value: _isDarkMode,
                    onChanged: _toggleDarkMode,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
