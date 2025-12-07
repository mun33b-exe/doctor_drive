import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/dtc_model.dart';

class DtcLocalDataSource {
  Future<List<DtcModel>> loadDtcDatabase() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/dtc_codes.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => DtcModel.fromJson(e)).toList();
  }
}
