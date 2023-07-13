// model for API to accept heart data
class Heart{
  final DateTime time;
  final int value;
  final String patient;

  Heart({required this.time, required this.value, required this.patient});

  Heart.fromJson(Map<String, dynamic> json, this.patient)
    : time = DateTime.parse(json['time']),
      value = json['value'];
}//Heart