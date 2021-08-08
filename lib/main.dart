import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:color_blindness_color_scheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Evil Insults',
        home: Homepage(),
        theme: ThemeData(
            colorScheme: ColorScheme.dark(primary: Color(0xffC2410C))));
  }
}

Future<Insult> fetchData() async {
  final response = await http
      .get('https://evilinsult.com/generate_insult.php?lang=en&type=json');
  if (response.statusCode == 200) {
    return Insult.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}

class Insult {
  String number;
  String language;
  String insult;
  String created;
  String shown;
  String createdby;
  String active;
  String comment;

  Insult(
      {this.number,
      this.language,
      this.insult,
      this.created,
      this.shown,
      this.createdby,
      this.active,
      this.comment});

  Insult.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    language = json['language'];
    insult = json['insult'];
    created = json['created'];
    shown = json['shown'];
    createdby = json['createdby'];
    active = json['active'];
    comment = json['comment'];
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<Insult> futureInsult;

  @override
  void initState() {
    futureInsult = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evil Insults'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<Insult>(
            future: futureInsult,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    snapshot.data.insult,
                    style: GoogleFonts.oxygen(),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        startDelay: Duration(milliseconds: 1000),
        glowColor: Colors.blue,
        endRadius: 90.0,
        duration: Duration(milliseconds: 5000),
        repeat: true,
        showTwoGlows: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              futureInsult = fetchData();
            });
          },
          child: Text('😈'),
          backgroundColor: Colors.white,
        ),
        shape: BoxShape.circle,
        animate: true,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }
}
