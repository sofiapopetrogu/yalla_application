class Steps{
  final DateTime time;
  final int value;

  Steps({required this.time, required this.value});

  Steps.fromJson(Map<String, dynamic> json)
    : time = DateTime.parse(json['time']),
      value = json['value'];
}//Steps