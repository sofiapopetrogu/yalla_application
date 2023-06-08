class RestingHeart{
  final DateTime time;
  final double value;

  RestingHeart({required this.time, required this.value});

  RestingHeart.fromJson(Map<String, dynamic> json)
    : time = DateTime.parse(json['time']),
      value = json['value'];
}//RestingHeart