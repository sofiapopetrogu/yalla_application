class Patients{
  final String username;
  final int birthyear;
  final String displayname;

  Patients({required this.username, required this.birthyear, required this.displayname});

Patients.fromJson(Map<String, dynamic> json)
    : username= json['username'],
      birthyear = json['birthyear'],
      displayname = json['displayname'];
}//Steps