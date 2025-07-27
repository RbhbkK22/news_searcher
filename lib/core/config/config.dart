

import 'dart:convert';

import 'package:flutter/services.dart';

final config = Config();

class Config {

  Config._internal();

  static final Config _instance = Config._internal();

  factory Config() => _instance;

  late Map<String, dynamic> _data;

  bool _isLoad = false;

  Future<void> load() async{
    if(!_isLoad){
      final jsonString = await rootBundle.loadString('assets/configs/config.json');
      _data = json.decode(jsonString);
      _isLoad = true;
    }
  }

  String get apiKey => _data['api_key'] as String;
}