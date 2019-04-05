import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fyp/services/rest_calls.dart';
import 'package:fyp/models/contact.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  const String url = 'https://abstrct-fyp.agilecrm.com/dev/api/';
  String _baseAuth = 'Basic ' + base64Encode(utf8.encode('o.anyabuike@nuigalway.ie:compsoc123')); 
  final headers = {
    'authorization' : _baseAuth,
  };

  group('fetchContact', () {
    test('throws exception if the http call completes with an error', () async {
      final client = MockClient();

      when(client.get(url + 'contacts/search/email/test@example.com', headers: headers))
        .thenAnswer((_) async => http.Response('', 204));

      expect(fetchContactFromCRM(client.toString()), throwsException);
    });
  });
}