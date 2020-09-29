import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

class APIService{

//  static const String _baseUrl = 'http://max-image-caption-generator-test.2886795282-80-kota04.environments.katacoda.com/model/predict';


Future<Map<String, dynamic>> fetchResponse(File image) async {

  final mimeTypeData = lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

  final http.MultipartRequest imageUploadRequest = http.MultipartRequest(
    'POST', 
    Uri.parse('http://max-image-caption-generator-test.2886795287-80-kota05.environments.katacoda.com/model/predict')
  );

  final http.MultipartFile file = await http.MultipartFile.fromPath(
    'image', image.path, 
    contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
  );
  

  imageUploadRequest.fields['ext'] = mimeTypeData[1];

  imageUploadRequest.files.add(file);


  try{

    final streamedResponse = await imageUploadRequest.send();

    final response = await http.Response.fromStream(streamedResponse);

    print('response code status: ${response.statusCode}');
    print('response body: ${response.body}');

    var encode = json.encode(response.body);

    final Map<String, dynamic> responseData = json.decode(response.body);

    print('responseData: $responseData');

    return responseData;

  } catch(e){
    
    print('error in catch $e');

    return null;
  }
}

String parseResponseCaption(var response){

  String r ='';
  var predictions = response['predictions'];

  for (var prediction in predictions) {
    String caption = prediction['caption'];
    // double probability = prediction['probability'];

    r = r + '$caption\n';
  }

  return r;
}

}

