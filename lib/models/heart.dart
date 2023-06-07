class Heart{
  final DateTime time;
  final int value;

  Heart({required this.time, required this.value});

  Heart.fromJson(Map<String, dynamic> json)
    : time = DateTime.parse(json['time']),
      value = json['value']
      ;
}//Steps