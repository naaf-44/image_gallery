import 'package:http/http.dart' as http;

class ApiRequest {
  /// getRequest is method which calls the GET request from http
  static getRequest(String url) async {
    var response = await http.get(Uri.parse(url));
    print("URL: ${Uri.parse(url)}");
    print("Response: ${response.body}");
    return response;
  }
}
