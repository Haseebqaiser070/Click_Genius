import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link_shortener/colors.dart';
import 'package:link_shortener/model/link.dart';
import 'package:link_shortener/statistics.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

class SingleLink extends StatefulWidget {
  SingleLink({Key? key, this.link}) : super(key: key);
  Link? link;
  @override
  _SingleLinkState createState() => _SingleLinkState();
}

class _SingleLinkState extends State<SingleLink> {
  TextEditingController realLinkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      realLinkController.text = widget.link!.realLink!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Material(
                elevation: 1,
                color: purpleBlue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: SafeArea(
                  child: SizedBox(
                    height: mHeight * 0.1069, // 99,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            '${widget.link!.shortenedLink}',
                            // 'https://www.google.com/0i131i433i457i512j0i402j0i433i512j0i',
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 36),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular((40)),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: QrImage(
                          data: '${widget.link!.shortenedLink}',
                          // 'https://pub.dev/packages/flutter_local_notifications/example',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 28),
              Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 55,
                  width: MediaQuery.of(context).size.width * 0.7, //* 0.8434, //
                  child: TextFormField(
                    controller: realLinkController,
                    decoration: InputDecoration(
                      enabled: false,
                      hintText: 'Link',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 5,
                        top: 12,
                        bottom: 12,
                      ),
                      child: InkWell(
                        onTap: () {
                          print('${widget.link!.shortenedLink}');
                          Clipboard.setData(ClipboardData(
                                  text: widget.link!.shortenedLink))
                              .then((value) {
                            print('Copied');
                            Fluttertoast.showToast(
                              msg:
                                  'Shortened Url ${widget.link!.shortenedLink} Copied',
                              toastLength: Toast.LENGTH_LONG,
                            );
                          });
                        },
                        child: SizedBox(
                          height:
                              (MediaQuery.of(context).size.width * 0.34) * 0.66,
                          // 75,
                          width:
                              (MediaQuery.of(context).size.width * 0.34) - 1.4,
                          // 120,
                          child: Material(
                            elevation: 1,
                            color: lightGreen,
                            borderRadius: BorderRadius.circular(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Copy\nLink',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SFPro',
                                      color: Color.fromARGB(255, 153, 153, 153),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.file_copy_rounded,
                                    color: Color.fromARGB(255, 153, 153, 153),
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                        top: 12,
                        bottom: 12,
                      ),
                      child: InkWell(
                        onTap: () {
                          Share.share(
                              'Check out my website ${widget.link!.shortenedLink} \nLook what I made on Click Genius.',
                              subject: 'Look what I made on Click Genius.');
                        },
                        child: SizedBox(
                          height:
                              (MediaQuery.of(context).size.width * 0.34) * 0.66,
                          //  75,
                          width:
                              (MediaQuery.of(context).size.width * 0.34) - 1.4,
                          //  120,
                          child: Material(
                            elevation: 1,
                            color: lightGreen,
                            borderRadius: BorderRadius.circular(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Share\nLink',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 153, 153, 153),
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SFPro',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.ios_share_rounded,
                                    color: Color.fromARGB(255, 153, 153, 153),
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 28.0),
              //   child: Material(
              //     elevation: 1,
              //     color: Colors.blueGrey,
              //     borderRadius: BorderRadius.circular(12),
              //     child: SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.6,
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: const [
              //             Padding(
              //               padding: EdgeInsets.all(8.0),
              //               child: Text(
              //                 'See the Stats',
              //                 style: TextStyle(
              //                   fontSize: 15.0,
              //                   color: lightGreen,
              //                   // fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //             ),
              //             Icon(
              //               Icons.stacked_bar_chart,
              //               color: lightGreen,
              //               size: 24,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                  height: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.0),
                    side: const BorderSide(color: lightGreen),
                  ),
                  child: Center(
                    child: SizedBox(
                      // width: MediaQuery.of(context).size.width * 0.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'See The Stats!',
                            style: TextStyle(
                              color: lightGreen,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SFPro',
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
                        builder: (context) => Statistics(
                          infoUrl: widget.link!.stats,
                        ),
                      ),
                    );
                  },
                  elevation: 4.0,
                  color: Colors.blueGrey, // grey,
                ),
              ),
              SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Shortened on ' +
                      '${widget.link!.date}'
                          .split(' ')
                          .first
                          .replaceAll('-', '.'),
                  // 'https://www.google.com/0i131i433i457i512j0i402j0i433i512j0i',
                  style: const TextStyle(
                    fontSize: 17.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'SFPro',
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
