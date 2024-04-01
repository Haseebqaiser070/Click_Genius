import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:link_shortener/colors.dart';
import 'package:link_shortener/model/api_response.dart';
import 'package:link_shortener/model/link.dart';
import 'package:link_shortener/recent_links.dart';
import 'package:link_shortener/single_link.dart';
import 'package:link_shortener/statistics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortLink extends StatefulWidget {
  ShortLink({Key? key, this.copyAllowed}) : super(key: key);
  bool? copyAllowed;
  @override
  State<ShortLink> createState() => _ShortLinkState();
}

class _ShortLinkState extends State<ShortLink> {
  bool? state;

  TextEditingController linkController = TextEditingController();

  int? cState = 0;

  Link? newLink;

  copyFromClipboard() async {
    // Clipboard.setData(const ClipboardData(text: "My Link"));
    // print(Clipboard.kTextPlain);
    var data = await Clipboard.getData('text/plain');

    if (data != null && data.text!.contains('http')) {
      print('{data!.text}');
      print('${data.text}');
      setState(() {
        linkController.text = data.text!;
      });
      shortTheLink();
    } else {
      //
      Fluttertoast.showToast(
        msg: 'No Url Detected.',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    if (widget.copyAllowed!) {
      copyFromClipboard();
    }
    // showModalBottomSheet(
    //   context: context,
    //   builder: (context) {
    //     return const SizedBox(
    //       height: 22,
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeBGColor,
      // bottomSheet: MyBottomSheet(),
      // resizeToAvoidBottomInset: true,
      bottomSheet: Container(
        height: 8,
        child: DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.6,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: // RecentLinks(),
                  Container(
                color: purpleBlue,
                child: SizedBox(
                  height: 120,
                  child: SvgPicture.asset('assets/icon_lila.svg'),
                ),
              ),
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              SvgPicture.asset(
                'assets/icon_lila.svg',
                color: homeLogoColor,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1414,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 34.0,
                        vertical: 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                'SHORTEN',
                                style: TextStyle(
                                  color: lightGreen,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Alphabold',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'your',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'OpenSans',
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'link now.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1414,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8434,
                      child: linkField(),
                    ),
                    SizedBox(height: 40),
                    MaterialButton(
                      minWidth: cState == 2
                          ? MediaQuery.of(context).size.width * 0.8434
                          : MediaQuery.of(context).size.width * 0.6,
                      height: 62,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(44.0),
                      ),
                      child: Text(
                        cState == 2 ? 'COPIED!' : 'SHORT THE LINK!',
                        style: const TextStyle(
                          color: grey,
                          fontSize: 18.0,
                          fontFamily: 'SFPro',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        if (linkController.text != "") {
                          shortTheLink();
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => Material(
                              elevation: 12,
                              child: SizedBox(
                                height: 80,
                                width: 200,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ('Link field is empty.'.toString()),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      elevation: 4.0,
                      color: lightGreen,
                    ),
                    const SizedBox(height: 34),
                    cState == 2
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5677,
                            height: 42,
                            child: MaterialButton(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.5677,
                              height:
                                  MediaQuery.of(context).size.height * 0.0259,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                side: const BorderSide(color: lightGreen),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'SEE THE STATS!',
                                        style: TextStyle(
                                          color: lightGreen,
                                          fontSize: 12.0,
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.stacked_bar_chart_sharp,
                                        color: lightGreen,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onPressed: () {
                                // removeList();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Statistics(infoUrl: newLink!.stats),
                                    // SingleLink(link: newLink),
                                  ),
                                );
                              },
                              elevation: 4.0,
                              color: homeBGColor,
                            ),
                          )
                        : Container(),
                    // DraggableScrollableSheet(
                    //   initialChildSize: 0.4,
                    //   minChildSize: 0.2,
                    //   maxChildSize: 0.6,
                    //   builder: (context, scrollController) {
                    //     return SingleChildScrollView(
                    //       controller: scrollController,
                    //       child: SizedBox(
                    //         height: 120,
                    //         child: SvgPicture.asset('assets/icon_lila.svg'),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
              // const Positioned(
              //   bottom: 0,
              //   child: MyBottomSheet(),
              // ),
              Positioned(
                bottom: 0,
                height: 88,
                child: DraggableScrollableSheet(
                  initialChildSize: 0.4,
                  minChildSize: 0.2,
                  maxChildSize: 0.6,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: SizedBox(
                        height: 120,
                        child: SvgPicture.asset('assets/icon_lila.svg'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget linkField() {
    return Center(
      child: SizedBox(
        height: 65,
        child: TextField(
          style: const TextStyle(
            color: grey,
            fontFamily: 'SFPro',
          ),
          controller: linkController,
          onChanged: (value) {
            setState(() {
              cState = 0;
            });
          },
          decoration: InputDecoration(
            focusColor: Colors.white,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: Colors.white),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            hintText: 'insert your link here',
            hintStyle: const TextStyle(
              color: grey,
              fontFamily: 'SFPro',
            ),
          ),
        ),
      ),
    );
  }

  Future shortTheLink() async {
    final iconUrl =
        await getFaviconFromUrl(linkController.text.trim()).then((value) {
      print('icon value $value');
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? realLink = linkController.text.trim();
    String? apiKey = '8cba62a4b14c90abe7206a2cdad41f5c0f84aafc';
    String? url = 'https://dev.click-genius.com/api?api=$apiKey&url=$realLink';
    // if (sharedPreferences.getString('apiKey') != null) {
    //   apiKey = sharedPreferences.getString('apiKey');
    // }
    print(apiKey);
    print(url);

    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      print(response.body);
      ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));

      newLink = Link(
        realLink: realLink,
        shortenedLink: apiResponse.shortenedUrl,
        stats: apiResponse.infoUrl,
        date: DateTime.now().toString(),
      );
      final link = Link(
        realLink: realLink,
        shortenedLink: apiResponse.shortenedUrl,
        stats: apiResponse.infoUrl,
        date: DateTime.now().toString(),
      ).toJson();
      setState(() {
        linkController.text = apiResponse.shortenedUrl!;
        // cState = 2;
      });
      Clipboard.setData(ClipboardData(text: linkController.text)).then((value) {
        print('Copied');
        setState(() {
          cState = 2;
        });
        Fluttertoast.showToast(
          msg: 'Shortened Url ${linkController.text} Copied',
          toastLength: Toast.LENGTH_LONG,
        );
      });
      print('link $link');
      String? encodeLink = jsonEncode(link);
      // sharedPreferences.getStringList('recentLinks');
      List<String>? recentLinks = [];
      if (sharedPreferences.getStringList('recentLinks') != null) {
        //
        recentLinks = sharedPreferences.getStringList('recentLinks');
      } else {
        recentLinks = [];
      }
      recentLinks!.add(encodeLink);
      sharedPreferences.setStringList('recentLinks', recentLinks);
      print('list saved');
    } else {
      print(response.body);
    }
  }

  Future removeList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    print('removed');
  }
}

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: true,
      backgroundColor: homeBGColor,
      onDragStart: (details) {
        print(details.localPosition.dx);
      },
      onClosing: () {},
      builder: (context) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecentLinks(),
              ),
            );
          },
          child: SizedBox(
            height: 113,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: const BoxDecoration(
                color: purpleBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(24),
                      child: const SizedBox(
                        height: 4,
                        width: 28,
                      ),
                    ),
                  ),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 24,
                        ),
                        child: Text(
                          'Your recent links',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SFPro',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Material(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    child: SizedBox(
                      height: 14,
                      width: MediaQuery.of(context).size.width * 0.8434,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
