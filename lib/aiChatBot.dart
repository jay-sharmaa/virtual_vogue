import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:virtualvogue/aiResponse.dart';


class ClothingSuggestionForm extends StatefulWidget {
  @override
  _ClothingSuggestionFormState createState() => _ClothingSuggestionFormState();
}

class _ClothingSuggestionFormState extends State<ClothingSuggestionForm> {
  final _formKey = GlobalKey<FormState>();

  // Input Variables
  String? event;
  String? theme;
  String? gender;
  String? style;
  String? season;
  String? temperature;
  String colorPreference = "";
  bool includeAccessories = false;

  // List of options for dropdowns
  final List<String> events = ["Wedding", "Party", "Casual", "Business", "Sports"];
  final List<String> themes = ["Formal", "Traditional", "Beach", "Vintage"];
  final List<String> genders = ["Male", "Female", "Non-binary"];
  final List<String> styles = ["Elegant", "Streetwear", "Minimalist", "Trendy"];
  final List<String> seasons = ["Summer", "Winter", "Spring", "Rainy"];
  final List<String> temperatures = ["Hot", "Cold", "Moderate"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Smart AI", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade800,
                  ),
                  child: Column(
                    children: [
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(" Confused,", style: TextStyle(color: Colors.white, fontSize: 40),)),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(" Get recommendations", style: TextStyle(color: Colors.grey.shade400, fontSize: 30),)),
        
                      Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(" from our", style: TextStyle(color: Colors.grey.shade400, fontSize: 30),)),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("  Smart AI !!", style: TextStyle(color: Colors.white, fontSize: 30),)),
                        ],
                      ),
        
                    ],
                  ),
                ),
        
                SizedBox(height: 30,),
                
                // Event Type Dropdown
                Padding(
                  padding: EdgeInsets.fromLTRB(10,0,0,10),
                  child: DropdownButtonFormField<String>(
                    value: event,
                    dropdownColor: Colors.black,
                    hint: Text("Select Event", style: TextStyle(color: Colors.white),),
                    onChanged: (value) => setState(() => event = value),
                    items: events.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Colors.white),))).toList(),
                  ),
                ),
        
                // Theme Dropdown
                Padding(
                  padding: EdgeInsets.fromLTRB(10,0,0,10),
                  child: DropdownButtonFormField<String>(
                    value: theme,
                    dropdownColor: Colors.black,
                    hint: Text("Select Theme", style: TextStyle(color: Colors.white),),
                    onChanged: (value) => setState(() => theme = value),
                    items: themes.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Colors.white)))).toList(),
                  ),
                ),
        
                // Gender Dropdown
                Padding(
                  padding: EdgeInsets.fromLTRB(10,0,0,10),
                  child: DropdownButtonFormField<String>(
                    value: gender,
                    dropdownColor: Colors.black,
                    hint: Text("Select Gender", style: TextStyle(color: Colors.white),),
                    onChanged: (value) => setState(() => gender = value),
                    items: genders.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Colors.white)))).toList(),
                  ),
                ),
        
                // Style Dropdown
                Padding(
                  padding: EdgeInsets.fromLTRB(10,0,0,10),
                  child: DropdownButtonFormField<String>(
                    value: style,
                    dropdownColor: Colors.black,
                    hint: Text("Select Style", style: TextStyle(color: Colors.white),),
                    onChanged: (value) => setState(() => style = value),
                    items: styles.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Colors.white)))).toList(),
                  ),
                ),
        
                // Season Dropdown
                Padding(
                  padding: EdgeInsets.fromLTRB(10,0,0,10),
                  child: DropdownButtonFormField<String>(
                    value: season,
                    dropdownColor: Colors.black,
                    hint: Text("Select Season", style: TextStyle(color: Colors.white),),
                    onChanged: (value) => setState(() => season = value),
                    items: seasons.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Colors.white)))).toList(),
                  ),
                ),
        
                // Temperature Dropdown
                Padding(
                  padding: EdgeInsets.fromLTRB(10,0,0,10),
                  child: DropdownButtonFormField<String>(
                    value: temperature,
                    dropdownColor: Colors.black,
                    hint: Text("Select Temperature", style: TextStyle(color: Colors.white),),
                    onChanged: (value) => setState(() => temperature = value),
                    items: temperatures.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Colors.white)))).toList(),
                  ),
                ),
        
                // Color Preference Text Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Color Preference (e.g., Red, Blue)",
                    labelStyle: TextStyle(color: Colors.white), // Label text color
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Border color when not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Border color when focused
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // Text color while typing
                  cursorColor: Colors.white, // Cursor color
                  onChanged: (value) => setState(() => colorPreference = value),
                ),
        
        
                // Include Accessories Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: includeAccessories,
                      onChanged: (value) => setState(() => includeAccessories = value!),
                    ),
                    Text("Include Accessories", style: TextStyle(color: Colors.white),)
                  ],
                ),
        
                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
        
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitForm();
                    }
                  },
                  child: Text("Get Recommendation", style: TextStyle(color: Colors.white),),
                ),
                SizedBox(height: 10,),
                Text(
                  "OR",
                  style: TextStyle(color: Colors.white, fontSize: 16), // Custom styling
                ),
                SizedBox(height: 10,),
        
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
        
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AiResponse(response: "",)));
                  },
                  child: Text("Type humanly..", style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
  String question = "I am attending a $event with a $theme theme. "
      "I identify as $gender and prefer a $style style. "
      "It's $season season, and the temperature is around $temperature°C. ";

  if (colorPreference.isNotEmpty) {
    question += "I prefer $colorPreference-colored clothes. ";
  }

  if (includeAccessories) {
    question += "Please also suggest some accessories.";
  }

  question += " What should I wear?";

  final Uri url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": question}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      String extractedText = jsonData["candidates"][0]["content"]["parts"][0]["text"];
      Navigator.push(context, MaterialPageRoute(builder: (context) => AiResponse(response: extractedText)));
    } else {
      showToast("Error: ${response.statusCode} - ${response.body}");
      print("Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    showToast("Request failed: $e");
    print("Request failed: $e");
  }
}


  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
