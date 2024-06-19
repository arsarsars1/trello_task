// import 'dart:convert';
//
// import 'package:flutter_web_auth/flutter_web_auth.dart';
// import 'package:http/http.dart' as http;
// import 'package:oauth2/oauth2.dart' as oauth2;
//
// class TodoistApi {
//   final String clientId = '==';
//   final String clientSecret = '==';
//   final String redirectUrl =
//       'com.ars.task_tracker_pro://callback'; // only issue exist here
//   final String authorizationEndpoint = 'https://todoist.com/oauth/authorize';
//   final String tokenEndpoint = 'https://todoist.com/oauth/access_token';
//
//   Future<oauth2.Client> authenticate() async {
//     final authorizationUri = Uri.parse(
//         '$authorizationEndpoint?client_id=$clientId&scope=data:read&redirect_uri=$redirectUrl');
//
//     final result = await FlutterWebAuth.authenticate(
//       url: authorizationUri.toString(),
//       callbackUrlScheme: 'valid-callback-scheme',
//     );
//
//     final code = Uri.parse(result).queryParameters['code'];
//
//     final tokenResponse = await http.post(
//       Uri.parse(tokenEndpoint),
//       body: {
//         'client_id': clientId,
//         'client_secret': clientSecret,
//         'code': code,
//         'redirect_uri': redirectUrl,
//       },
//     );
//
//     final tokenData = json.decode(tokenResponse.body);
//     final credentials = oauth2.Credentials(tokenData['access_token']);
//
//     return oauth2.Client(credentials);
//   }
//
//   Future<List<dynamic>> getProjects(oauth2.Client client) async {
//     final url = Uri.parse('https://api.todoist.com/rest/v2/projects');
//     final response = await client.get(url);
//
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load projects');
//     }
//   }
// }
