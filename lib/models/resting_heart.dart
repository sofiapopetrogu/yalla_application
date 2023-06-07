class RestingHeart{
  final DateTime time;
  final int value;
  final double error;

  RestingHeart({required this.time, required this.value, required this.error});

  RestingHeart.fromJson(Map<String, dynamic> json)
    : time = DateTime.parse(json['time']),
      value = json['value'],
      error = json['error'];
}//Steps