class Link {
  String? realLink;
  String? shortenedLink;
  String? iconUrl;
  String? stats;
  String? date;

  Link({
    this.realLink,
    this.shortenedLink,
    this.iconUrl,
    this.stats,
    this.date,
  });

  Link.fromJson(Map<String, dynamic> json) {
    realLink = json['realLink'];
    shortenedLink = json['shortenedLink'];
    iconUrl = json['iconUrl'];
    stats = json['stats'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['realLink'] = realLink;
    data['shortenedLink'] = shortenedLink;
    data['iconUrl'] = iconUrl;
    data['stats'] = stats;
    data['date'] = date;
    return data;
  }
}
