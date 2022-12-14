import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String _basicAuth = 'Basic ' + base64Encode(utf8.encode('haytham:ww227'));

Map<String, String> myheaders = {'authorization': _basicAuth};

class Crud {
  //get method
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        response = jsonDecode(response.body);
        return response.body;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch");
    }
  }

  //post method

  postRequest(String url, Map data) async {
    try {
      var response =
          await http.post(Uri.parse(url), body: data, headers: myheaders);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("$e");
    }
  }
}

//ulpoad file from flutter

postRequestWithFile(String url, Map data, File file) async {
  var request = http.MultipartRequest("POST", Uri.parse(url));
  var lenght = await file.length();
  var stream = http.ByteStream(file.openRead());
  var multipartFile =
      http.MultipartFile("file", stream, lenght, filename: basename(file.path));
  request.headers.addAll(myheaders);
  request.files.add(multipartFile); //for file
  data.forEach((key, value) {
    request.fields[key] = value;
  });
  var myrequest = await request.send();
  var response = await http.Response.fromStream(myrequest);
  if (myrequest.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print("Error${myrequest.statusCode}");
  }
}
