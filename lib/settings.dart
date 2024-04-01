import 'package:flutter/material.dart';
import 'package:link_shortener/change_api_key.dart';
import 'package:link_shortener/colors.dart';
import 'package:link_shortener/help_center.dart';
import 'package:link_shortener/terms_and_conditions.dart';
import 'package:link_shortener/visit_our_website.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 243),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const Positioned(
            bottom: 40,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'ClickGenius 1.0.0',
                style: TextStyle(
                  fontSize: 17.0,
                  fontFamily: 'SFPro',
                  color: Color.fromARGB(255, 153, 153, 153),
                ),
              ),
            ),
          ),
          Center(
            child: ListView(
              children: [
                Material(
                  elevation: 1,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 4.0,
                        top: 28.0,
                        bottom: 6.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                size: 24,
                                color: homeBGColor,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SFPro',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24, width: 24)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                  width: 12,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeApiKey(),
                      ),
                    );
                  },
                  child: MyTile(text: 'Change API Key'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsAndConditions(),
                      ),
                    );
                  },
                  child: MyTile(text: 'Terms & Conditions'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpCenter(),
                      ),
                    );
                  },
                  child: MyTile(text: 'Help Center'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VisitOurWebsite(),
                      ),
                    );
                  },
                  child: MyTile(text: 'Visit our website'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyTile extends StatelessWidget {
  MyTile({
    Key? key,
    this.text,
  }) : super(key: key);
  String? text;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text!,
                  // 'Terms & Conditions',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 17.0,
                    // fontWeight: FontWeight.w600,
                    fontFamily: 'SFPro',
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
              )
            ],
          ),
        ),
      ),
    );
  }
}
