import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link_shortener/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeApiKey extends StatefulWidget {
  const ChangeApiKey({Key? key}) : super(key: key);

  @override
  _ChangeApiKeyState createState() => _ChangeApiKeyState();
}

class _ChangeApiKeyState extends State<ChangeApiKey> {
  TextEditingController apiKeyController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getAPIKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 242, 243),
      body: Center(
        child: ListView(
          children: [
            Material(
              elevation: 0,
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    top: 28.0,
                    bottom: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 24,
                            color: homeBGColor,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Change Api Key',
                          style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                        width: 12,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
              width: 12,
            ),
            Material(
              elevation: 0,
              // borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: TextFormField(
                    controller: apiKeyController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Value',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                saveAPIKey();
              },
              child: Text('SAVE'),
            ),
            const SizedBox(
              height: 40,
              width: 12,
            ),
            apiKey != ''
                ? Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 44.0, vertical: 16),
                      child: Text(
                        'Current API Key:\n$apiKey',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'SFPro',
                          color: Color.fromARGB(255, 100, 100, 100),
                        ),
                      ),
                    ),
                  )
                : Container(),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 54.0),
                child: Text(
                  '94lvrti594489tr-urijk-eiodk9e_eifefdeifkei-eksffefdeik-eerkekjdiejeipwowp-w[s9wweioewoiwidsoswossdfklj93457eiwsd-0-3iwrswoej',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontFamily: 'SFPro',
                    color: Color.fromARGB(255, 153, 153, 153),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future saveAPIKey() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? apiKey = apiKeyController.text.trim();
    sharedPreferences.setString('apiKey', apiKey).then((value) {
      Fluttertoast.showToast(
        msg: 'Saved',
        toastLength: Toast.LENGTH_LONG,
      );
      setState(() {
        apiKeyController.text = '';
      });
    });
  }

  String? apiKey = '';
  Future getAPIKey() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getString('apiKey') != null) {
      setState(() {
        apiKey = sharedPreferences.getString('apiKey');
      });
    } else {
      setState(() {
        apiKey = '';
        // '8cba62a4b14c90abe7206a2cdad41f5c0f84aafc';
      });
    }
  }
}
