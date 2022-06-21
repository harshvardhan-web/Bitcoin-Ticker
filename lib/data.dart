import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'main.dart';

const apiKey = "D71B0C89-7ED0-47BB-97EC-D092EDD27D8A";

const List<String> crypto = ['BTC','ETH','LTC'];
const List<String> curreny = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];