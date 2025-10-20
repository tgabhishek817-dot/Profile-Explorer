import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/profile.dart';

class ProfilesApi {
  final http.Client client;
  ProfilesApi({http.Client? client}) : client = client ?? http.Client();

  Future<List<Profile>> fetchProfiles({int results = 20}) async {
    final uri = Uri.parse('https://randomuser.me/api/?results=$results');
    final resp = await client.get(uri);
    if (resp.statusCode != 200) throw Exception('Failed to load profiles');
    final Map<String, dynamic> map = json.decode(resp.body);
    final List resultsList = map['results'];
    return resultsList.map((e) => Profile.fromJson(e)).toList();
  }
}
