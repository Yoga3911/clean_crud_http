import 'dart:developer';

import 'package:clean_crud/model/warga.dart';
import 'package:http/http.dart' as http;

class Services {
  static final _url =
      Uri.parse('http://192.168.43.39/php/clean_http/index.php');
  static const _table = 'CREATE_TABLE';
  static const _get = 'GET_ALL';
  static const _add = 'ADD_WARGA';
  static const _update = 'UPDATE_WARGA';
  static const _delete = 'DELETE_WARGA';

  // Create Table if doesnt exists
  static Future<String> createTable() async {
    final request = await http.post(_url, body: {"action": _table});
    inspect(request.body);
    if (request.statusCode == 200) {
      return request.body;
    } else {
      return "error";
    }
  }

  // Get all data from table
  static Future<List<Warga>> getWarga() async {
    final request = await http.post(_url, body: {"action": _get});
    if (request.statusCode == 200) {
      List<Warga> response = wargaFromJson(request.body);
      return response;
    } else {
      return [];
    }
  }

  // Add data to table
  static Future<String> addData(String nama, String umur) async {
    final request = await http
        .post(_url, body: {"action": _add, "nama": nama, "umur": umur});

    if (request.statusCode == 200) {
      return request.body;
    } else {
      return "error";
    }
  }

  // Update data in table
  static Future<String> updateData(String id, String nama, String umur) async {
    final request = await http.post(_url,
        body: {"action": _update, "id": id, "nama": nama, "umur": umur});

    inspect(request);
    if (request.statusCode == 200) {
      return request.body;
    } else {
      return "error";
    }
  }

  // Detele data in table
  static Future<String> deleteData(String id) async {
    final request = await http.post(_url, body: {"action": _delete, "id": id});

    if (request.statusCode == 200) {
      return request.body;
    } else {
      return "error";
    }
  }
}
