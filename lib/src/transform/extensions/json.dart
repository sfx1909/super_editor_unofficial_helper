import 'dart:convert';

import 'package:super_editor/super_editor.dart';

import '../json/json.dart';

extension JsonDocument on Document {
  Map<String, dynamic> toMap({
    //Append a list of keys containing the order of nodes
    ///
    /// This is useful if you are using something like Firebase Firestore with sorts data on creation
    bool appendOrder = false,

    ///Will retain the node id found in the document
    ///
    /// If `false` then nodes will be returned in a list
    bool keepID = true,
  }) =>
      documentToMap(this, appendOrder: appendOrder, keepID: keepID);

  String toJson({
    //Append a list of keys containing the order of nodes
    ///
    /// This is useful if you are using something like Firebase Firestore with sorts data on creation
    bool appendOrder = false,

    ///Will retain the node id found in the document
    ///
    /// If `false` then nodes will be returned in a list
    bool keepID = true,
  }) =>
      json.encode(toMap(appendOrder: appendOrder, keepID: keepID));

  static MutableDocument fromMap(Map<String, dynamic> map) =>
      mapToDocument(map);

  static MutableDocument fromJson(String source) =>
      JsonDocument.fromMap(json.decode(source));
}
