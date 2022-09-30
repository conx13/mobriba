import 'dart:developer';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

/* -------------------------------------------------------------------------- */
/*                          Kogu HTTP päringute jaoks                         */
/* -------------------------------------------------------------------------- */

String url = 'http://10.0.30.154:3000/api'; //Matek Raspeberry;
//String url = 'http://10.0.30.192:3000/api'; //Matek Wifi
//String url = 'http://10.0.30.155:3000/api'; //Matek Raspeberry;
//String url = 'http://192.168.1.202:3000/api/rkood/$data'; //Kodus
//String url = 'http://192.168.8.100:3000/api/rkood/$data';
//String url = 'http://192.168.1.138:3000/api/rkood/$data';

//Ajutiselt aktiveerin basicauth, et natuke oleks turvalisem
String username = 'matek';
String password = '123£-UYh4-8UXx';
String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

Map<String, String> httpPais = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, GET, PUT, DELETE, HEAD',
  "Access-Control-Allow-Credentials": 'true',
  'content-type': 'application/json',
  'accept': 'application/json',
  'authorization': basicAuth
};

/* -------------------------------------------------------------------------- */
/*                             Tavaline GET päring                            */
/* -------------------------------------------------------------------------- */
Future getData(String data) async {
  //log(Uri.parse(Uri.encodeFull('$url$data')).toString(), name: 'HTTP url:');
  final response =
      await get(Uri.parse(Uri.encodeFull('$url$data')), headers: httpPais)
          .timeout(const Duration(seconds: 40),
              onTimeout: () => Response('Timeout', 408));
  //log(response.body.toString(), name: 'HTTP service:');
  if (response.statusCode == 200) {
    return ((response.body));
  } else {
    log('http ERROR: ${response.body}', name: 'HTTP service error');
    throw Exception(response.body);
  }
}

/* -------------------------------------------------------------------------- */
/*                               Tavaline delete                              */
/* -------------------------------------------------------------------------- */
Future delData(String data) async {
  final response = await delete(Uri.parse('$url$data'), headers: httpPais)
      .timeout(const Duration(seconds: 20),
          onTimeout: () => Response('Timeout', 408));
  if (response.statusCode == 200) {
    //log(response.body.toString(), name: 'HTTP DELETE:');
    return ((response.body));
  } else {
    log('http ERROR: ${response.body}', name: 'HTTP service error');
    throw Exception("Miskit läks kustutamisega valesti!");
  }
}

/* -------------------------------------------------------------------------- */
/*                                Muudame pilti                               */
/* -------------------------------------------------------------------------- */
Future postPicture(picture, tid) async {
  var request = MultipartRequest('POST', Uri.parse('$url/users/editpic/$tid'))
    ..files.add(await MultipartFile.fromPath('pilt', picture,
        contentType: MediaType('image', 'jpeg')))
    ..headers.addAll(httpPais);
  var response = await request.send();
  if (response.statusCode != 200) {
    throw Exception("Miskit läks päringuga valesti!");
  } else {
    return await response.stream.bytesToString();
  }
}
