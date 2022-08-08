import 'dart:convert';

import 'package:super_editor/super_editor.dart';
import 'package:super_editor_unofficial_helper/extensions.dart';
import 'package:super_editor_unofficial_helper/transform.dart';

final document = MutableDocument(nodes: [
  /* some nodes */
]);

// To json and map
var map1 = documentToMap(document);
var json1 = json.encode(map1);

//extensions
var json2 = document.toJson();
var map2 = document.toMap();

// from
var doc1 = mapToDocument(map1);
var doc2 = mapToDocument(json.decode(json1));

//extensions
var doc3 = JsonDocument.fromMap(map1);
var doc4 = JsonDocument.fromJson(json1);
