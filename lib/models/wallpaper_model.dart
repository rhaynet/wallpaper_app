class Wallpaper {
  late String photographer;
  late String photographer_url;
  late int photographer_id;
  late SrcModel src;

  Wallpaper({
    required this.photographer,
    required this.photographer_id,
    required this.photographer_url,
    required this.src,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
      photographer: json['photographer'],
      photographer_id: json['photographer_id'],
      photographer_url: json['photographer_url'],
      src: SrcModel.fromJson(json['src']),
    );
  }
}

class SrcModel {
  late String original;
  late String small;
  late String portrait;

  SrcModel({
    required this.original,
    required this.portrait,
    required this.small,
  });

  factory SrcModel.fromJson(Map<String, dynamic> json){
    return SrcModel(
      original: json['original'],
      portrait: json['portrait'],
      small: json['small'],
    );
  }
}
