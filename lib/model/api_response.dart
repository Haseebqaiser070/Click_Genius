import 'package:favicon/favicon.dart';

class ApiResponse {
  String? status;
  String? message;
  String? infoUrl;
  String? shortenedUrl;

  ApiResponse({this.status, this.message, this.infoUrl, this.shortenedUrl});

  ApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    infoUrl = json['info_url'];
    shortenedUrl = json['shortenedUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['info_url'] = infoUrl;
    data['shortenedUrl'] = shortenedUrl;
    return data;
  }
}

Future<String?> getFaviconFromUrl(String? url) async {
  print('fetching favicon');
  // import 'package:favicon/favicon.dart';
  //  https://www.mashable.com/favicons/favicon.svg
  // https://www.facebook.com/favicon.ico
  var iconUrl = await Favicon.getBest(url!);
  // 'https://iqonic.design/shop/filter_session/PKCI97AEHN/');
  // Favicon.getAll('url',suffixes: ['s','as']);
  print('fetched icon is $iconUrl');
  return iconUrl!.url;
}
