// model for API to accept steps data
class Steps{
  final DateTime time;
  final int value;
  final String patient;

  Steps({required this.time, required this.value, required this.patient});

  Steps.fromJson(Map<String, dynamic> json, this.patient)
    : time = DateTime.parse(json['time']),
      value = json['value'];
}//Steps