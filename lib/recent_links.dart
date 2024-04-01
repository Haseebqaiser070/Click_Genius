import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link_shortener/colors.dart';
import 'package:link_shortener/model/link.dart';
import 'package:link_shortener/settings.dart';
import 'package:link_shortener/short_the_link.dart';
import 'package:link_shortener/single_link.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentLinks extends StatefulWidget {
  const RecentLinks({Key? key}) : super(key: key);

  @override
  _RecentLinksState createState() => _RecentLinksState();
}

class _RecentLinksState extends State<RecentLinks> {
  List<String>? recentLinksList = [];

  int? copiedIndex;

  @override
  void initState() {
    super.initState();
    getRecentLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleBlue,
      body: Container(
        child: Center(
          child: Stack(
            children: [
              Positioned(
                bottom: -90,
                right: 0,
                child: SvgPicture.asset(
                  'assets/icon_lila.svg',
                  color: homeLogoColor,
                  height: MediaQuery.of(context).size.height * 0.58,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(32),
                        child: const SizedBox(
                          height: 4,
                          width: 28,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 30.0,
                        right: 30.0,
                        bottom: 44,
                        top: 32,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Settings(),
                                ),
                              );
                            },
                            child: const RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.settings_rounded,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/icon_lila.svg',
                            color: Colors.white,
                            height: 35,
                          ),
                          // Text(
                          //   'LOGO',
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 22.0,
                          //     fontWeight: FontWeight.w700,
                          //   ),
                          // ),
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ShortLink(copyAllowed: false),
                                  ),
                                  (route) => false);
                            },
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 28,
                            left: 30,
                            bottom: 8,
                          ),
                          child: Text(
                            'Your recent links',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SFPro',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(
                            // top: 30,
                            left: 30,
                            bottom: 4,
                          ),
                          child: Text(
                            'Long Press to Copy Link',
                            style: TextStyle(
                              fontSize: 11.0,
                              fontFamily: 'SFPro',
                              color: Color.fromARGB(222, 253, 253, 253),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // ListView(
                    //   children: List.generate(12, (index) => Text('data')).toList(),
                    //   addAutomaticKeepAlives: true,
                    // )
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.height - 199, // 490 - 19,
                      child: recentLinksList!.length != 0
                          ? ListView.builder(
                              itemCount: recentLinksList!.length, // 16,
                              itemBuilder: (context, index) {
                                // copiedIndex = recentLinksList!.length + 2;
                                // print('copiedIndex= $copiedIndex');
                                print(
                                    'index= $index' + recentLinksList![index]);
                                Map<String, dynamic> decodeRecentLink =
                                    jsonDecode(recentLinksList![index]);
                                var recentLink =
                                    Link.fromJson(decodeRecentLink);
                                print(recentLink.realLink!);
                                print(recentLink.shortenedLink!);
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 34.0,
                                    right: 34.0,
                                    bottom: 16.0,
                                  ),
                                  child: InkWell(
                                    onLongPress: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                            text: recentLink.shortenedLink!),
                                      ).then((value) {
                                        Fluttertoast.showToast(
                                          msg: 'Copied!',
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                        setState(() {
                                          copiedIndex = index;
                                        });
                                      });
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SingleLink(link: recentLink),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Material(
                                          elevation: 8,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/google.svg',
                                                    color: purpleBlue,
                                                    height: 18,
                                                    width: 18,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.65,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        '${recentLink.shortenedLink}'
                                                            .substring(0, 33),
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontSize: 17.0,
                                                          fontFamily: 'SFPro',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 14,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        copiedIndex == index
                                            ? Material(
                                                elevation: 8,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Material(
                                                        color: lightGreen,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16.0),
                                                          child: Text(
                                                            'COPIED!',
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontSize: 17.0,
                                                              fontFamily:
                                                                  'SFPro',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.6) -
                                                            7,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            '${recentLink.shortenedLink}'
                                                                .substring(
                                                                    0, 30),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 17.0,
                                                              fontFamily:
                                                                  'SFPro',
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                'No Link Found',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SFPro',
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getRecentLinks() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getStringList('recentLinks') != null) {
      print('listfound');
      recentLinksList = sharedPreferences.getStringList('recentLinks');
      // recentLinksList!.removeAt(0);
      for (var i = 0; i < recentLinksList!.length; i++) {
        print('i= $i' + recentLinksList![i]);
        Map<String, dynamic> decodeRecentLink = jsonDecode(recentLinksList![i]);
        var recentLink = Link.fromJson(decodeRecentLink);
        print(recentLink.shortenedLink!);
      }
    } else {
      print('not found');

      recentLinksList = [];
    }
    setState(() {});
  }
}
