import 'dart:convert';
import 'package:project_app/util/impact.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {

//This method allows to check if the IMPACT backend is up
  static Future<bool> isImpactUp() async {

    //Create the request
    final url = Impact.baseUrl + Impact.pingEndpoint;

    //Get the response
    final response = await http.get(Uri.parse(url));

    //Just return if the status code is OK
    return response.statusCode == 200;
  } //isImpactUp

  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  static Future<int> getAndStoreTokens() async {

    //Create the request
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': Impact.username, 'password': Impact.password};

    //Get the response
    final response = await http.post(Uri.parse(url), body: body);

    //If response is OK, decode it and store the tokens. Otherwise do nothing.
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    } 

    //Just return the status code
    return response.statusCode;
  } //getAndStoreTokens

  //This method allows to refrsh the stored JWT in SharedPreferences
  static Future<int> refreshTokens() async {

    //Create the request 
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    //Get the response
    final response = await http.post(Uri.parse(url), body: body);

    //If the response is OK, set the tokens in SharedPreferences to the new values
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Just return the status code
    return response.statusCode;
    
  } //refreshTokens


}