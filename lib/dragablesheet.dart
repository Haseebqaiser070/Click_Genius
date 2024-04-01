import 'dart:async';
import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:link_shortener/model/api_response.dart';
import 'package:link_shortener/model/link.dart';
import 'package:link_shortener/settings.dart';
import 'package:link_shortener/single_link.dart';
import 'package:link_shortener/statistics.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';

class MyDragableSheet extends StatefulWidget {
  MyDragableSheet({Key? key, this.copyAllowed}) : super(key: key);
  bool? copyAllowed;

  @override
  _MyDragableSheetState createState() => _MyDragableSheetState();
}

class _MyDragableSheetState extends State<MyDragableSheet>
    with WidgetsBindingObserver {
  bool? state;

  TextEditingController linkController = TextEditingController();

  int? cState = 0;

  Link? newLink;
  int? copiedIndex;
  List<String>? recentLinksList = [];
  Future getRecentLinks() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.clear();
    if (sharedPreferences.getStringList('recentLinks') != null) {
      print('listfound');
      recentLinksList = sharedPreferences.getStringList('recentLinks');
      for (var i = 0; i < recentLinksList!.length; i++) {
        // print('i= $i' + recentLinksList![i]);
        Map<String, dynamic> decodeRecentLink = jsonDecode(recentLinksList![i]);
        var recentLink = Link.fromJson(decodeRecentLink);
        print(recentLink.shortenedLink!);
      }
      print('reverse');
      // print(recentLinksList!.reversed);
      recentLinksList = recentLinksList!.reversed.toList();
    } else {
      print('not found');

      recentLinksList = [];
    }
    setState(() {});
  }

  // @override
  // void initState() {
  //   super.initState();
  // getRecentLinks();
  // }

  copyFromClipboard() async {
    setState(() {
      cState = 0;
      linkController.text = '';
    });
    // final data = await Clipboard.getData('text/plain'); // var
    // if (data != null && data.text!.contains('http')) {
    // if (data != null) {
    //   //&& cState == 0
    //   print('{data!.text}');
    //   print('${data.text}');
    //   setState(() {
    //     linkController.text = data.text!;
    //   });
    //   shortTheLink();
    // } else {
    //   // Fluttertoast.showToast(
    //   //   msg: 'No Url Detected.',
    //   //   toastLength: Toast.LENGTH_LONG,
    //   // );
    // }
    Timer(Duration(seconds: 2), () {
      print('2 seconds');
      Clipboard.getData(Clipboard.kTextPlain).then((value) {
        print('clipboard value');
        print(value);
        setState(() {
          linkController.text = value!.text!;
        });
        shortTheLink();
        Fluttertoast.showToast(
          msg: '${value!.text}.',
          toastLength: Toast.LENGTH_LONG,
        );
      });
    });
  }

  copyFromClipboard22() {
    FlutterClipboard.paste().then((value) {
      setState(() {
        linkController.text = value;
      });
      shortTheLink();
      Fluttertoast.showToast(
        msg: '$value.',
        toastLength: Toast.LENGTH_LONG,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    if (widget.copyAllowed!) {
      copyFromClipboard();
    }

    getRecentLinks();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        // print(
        //     'appLifeCycleState inactive\niiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
        break;
      case AppLifecycleState.resumed:
        // print(
        //     'appLifeCycleState resumed\nrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
        // setState(() {
        //   cState = 0;
        //   linkController.text = '';
        // });
        copyFromClipboard();
        break;
      case AppLifecycleState.paused:
        // print(
        //     'appLifeCycleState paused\nppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp');
        // setState(() {
        //   cState = 0;
        //   linkController.text = '';
        // });
        break;
      case AppLifecycleState.detached:
        // print(
        //     'appLifeCycleState detached\nddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');
        // setState(() {
        //   cState = 0;
        //   linkController.text = '';
        // });
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeBGColor,
      body: Stack(
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
                  // height: 55,
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
                    if (linkController.text != "" && cState == 0) {
                      shortTheLink();
                    } else if (cState == 2) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        ('Link is already shortened.'
                                            .toString()),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        ('Link field is empty.'.toString()),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  elevation: 4.0,
                  color: lightGreen,
                ),
                // Container(
                //   height: 14,
                //   decoration: const BoxDecoration(
                //     color: Colors.red,
                //     image: DecorationImage(
                //       image: NetworkImage(
                //           // 'https://www.facebook.com/favicon.ico'),
                //           'https://www.mashable.com/favicons/favicon.svg'),
                //     ),
                //   ),
                // ),
                // SvgPicture.network(
                //     'https://www.mashable.com/favicons/favicon.svg'),
                const SizedBox(height: 34),
                cState == 2
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5677,
                        height: 42,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width * 0.5677,
                          height: MediaQuery.of(context).size.height * 0.0259,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            side: const BorderSide(color: lightGreen),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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

                // NetworkImage('https://www.mashable.com/favicons/favicon.svg'),
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

          // SvgPicture.asset(
          //   'assets/icon_lila.svg',
          //   fit: BoxFit.cover,
          //   height: 200,
          // ),
          Stack(
            // fit: StackFit.expand,
            children: [
              // SvgPicture.asset(
              //   'assets/icon_lila.svg',
              //   fit: BoxFit.cover,
              //   height: 200,
              // ),
              DraggableScrollableSheet(
                initialChildSize: 0.12,
                minChildSize: 0.1,
                maxChildSize: 1, // 0.6,
                builder: (context, scrollController) {
                  // getRecentLinks();
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      decoration: BoxDecoration(
                        color: purpleBlue, //Colors.white70,
                        borderRadius: BorderRadius.circular(32),
                      ),
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
                          Column(
                            children: [
                              InkResponse(
                                onTap: () {
                                  //
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(32),
                                    child: const SizedBox(
                                      height: 4,
                                      width: 28,
                                    ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MyDragableSheet(
                                              copyAllowed: false,
                                            ),
                                          ),
                                          (route) => false,
                                        );
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
                              Transform.translate(
                                offset: Offset(
                                  0,
                                  // scrollController
                                  //     .initialScrollOffset, //
                                  0, //  -122,
                                ),
                                filterQuality: FilterQuality.high,
                                child: Row(
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
                                        color:
                                            Color.fromARGB(222, 253, 253, 253),
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
                                height: MediaQuery.of(context).size.height -
                                    199, // 490 - 19,
                                child: recentLinksList!.length != 0
                                    ? ListView.builder(
                                        itemCount:
                                            recentLinksList!.length, // 16,
                                        itemBuilder: (context, index) {
                                          // copiedIndex = recentLinksList!.length + 2;
                                          // print('copiedIndex= $copiedIndex');
                                          // print('index= $index' +
                                          //     recentLinksList![index]);
                                          Map<String, dynamic>
                                              decodeRecentLink = jsonDecode(
                                                  recentLinksList![index]);
                                          var recentLink =
                                              Link.fromJson(decodeRecentLink);
                                          // print(recentLink.realLink!);
                                          // print(recentLink.shortenedLink!);
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
                                                      text: recentLink
                                                          .shortenedLink!),
                                                ).then((value) {
                                                  Fluttertoast.showToast(
                                                    msg: 'Copied!',
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                  );
                                                  setState(() {
                                                    copiedIndex = index;
                                                  });
                                                  fadeCopyButton();
                                                });
                                              },
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SingleLink(
                                                            link: recentLink),
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  Material(
                                                    elevation: 8,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            recentLink.iconUrl!
                                                                        .contains(
                                                                            '.svg') &&
                                                                    recentLink
                                                                            .iconUrl !=
                                                                        null
                                                                ? SvgPicture
                                                                    .network(
                                                                    recentLink
                                                                        .iconUrl!,
                                                                    // 'assets/google.svg',
                                                                    color:
                                                                        purpleBlue,
                                                                    height: 18,
                                                                    width: 18,
                                                                  )
                                                                : Container(
                                                                    height: 18,
                                                                    width: 18,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      // color: Colors
                                                                      //     .white,
                                                                      image:
                                                                          DecorationImage(
                                                                        image: NetworkImage(
                                                                            recentLink.iconUrl!),
                                                                        // 'https://www.facebook.com/favicon.ico'),
                                                                        // 'https://www.mashable.com/favicons/favicon.svg'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.65,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  '${recentLink.shortenedLink}',
                                                                  //     .substring(
                                                                  //         0,
                                                                  //         33),
                                                                  maxLines: 1,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        17.0,
                                                                    fontFamily:
                                                                        'SFPro',
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
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Material(
                                                                  color:
                                                                      lightGreen,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  child:
                                                                      const Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            16.0),
                                                                    child: Text(
                                                                      'COPIED!',
                                                                      maxLines:
                                                                          1,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            17.0,
                                                                        fontFamily:
                                                                            'SFPro',
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: (MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.6) -
                                                                      7,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      '${recentLink.shortenedLink}'
                                                                          .substring(
                                                                              0,
                                                                              30),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            17.0,
                                                                        fontFamily:
                                                                            'SFPro',
                                                                        overflow:
                                                                            TextOverflow.clip,
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
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
          onTap: () {
            print('field is tapped');
          },
          keyboardType: TextInputType.emailAddress,
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

  // getFaviconFromUrl() async {
  //   // import 'package:favicon/favicon.dart';
  //   var iconUrl = await Favicon.getBest('https://www.mashable.com');
  //   print(iconUrl);
  // }

  Future shortTheLink() async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.show();

    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return Center(
    //         child: SizedBox(
    //           height: 32,
    //           width: 32,
    //           child: CircularProgressIndicator(
    //             color: purpleBlue,
    //           ),
    //         ),
    //       );
    //     });
    // String? iconUrl;
    final iconUrl = await getFaviconFromUrl(linkController.text.trim());
    //     .then((value) {
    //   print('icon value $value');
    //   setState(() {
    //     iconUrl = value;
    //   });
    // });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? realLink = linkController.text.trim();
    String? apiKey = '8cba62a4b14c90abe7206a2cdad41f5c0f84aafc';
    // dev.click-genius.com
    String? url = 'https://click-genius.com/api?api=$apiKey&url=$realLink';
    if (sharedPreferences.getString('apiKey') != null) {
      apiKey = sharedPreferences.getString('apiKey');
    }
    print(apiKey);
    print(url);

    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('200');
      print(response.body);
      ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));

      newLink = Link(
        realLink: realLink,
        shortenedLink: apiResponse.shortenedUrl,
        iconUrl: iconUrl,
        stats: apiResponse.infoUrl,
        date: DateTime.now().toString(),
      );
      final link = Link(
        realLink: realLink,
        shortenedLink: apiResponse.shortenedUrl,
        iconUrl: iconUrl,
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
      // newly added for updating the the recent list
      getRecentLinks();
      await dialog.hide();
    } else {
      print(response.body);
      await dialog.hide();

      Fluttertoast.showToast(
        msg: 'Some Error occur.',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void fadeCopyButton() {
    Timer(Duration(seconds: 5), () {
      setState(() {
        copiedIndex = recentLinksList!.length + 9;
      });
    });
  }
}
