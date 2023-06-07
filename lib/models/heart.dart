class Heart{
  final DateTime time;
  final int value;
  final double error;

  Heart({required this.time, required this.value, required this.error});

  Heart.fromJson(Map<String, dynamic> json)
    : time = DateTime.parse(json['time']),
      value = json['value'],
      error = json['error'];
}//Steps