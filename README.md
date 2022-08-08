Adds a basic JSON serializer for [super_editor](https://pub.dev/packages/super_editor) and adds extensions for the JSON
serializer and the markdown serializer. Made with Love <3

## Features

- Allows JSON serialization of the awesome super_editor
- Some utility extensions

## Getting started

Install

```
flutter pub add super_edito_unofficial_helper
```

Import

```dart
import 'package:super_editor/super_editor.dart';
import 'package:super_editor_unofficial_helper/super_editor_unofficial_helper.dart';
```

(Import) Specific

```dart
import 'package:super_editor_unofficial_helper/extensions.dart';
import 'package:super_editor_unofficial_helper/transform.dart';
```

## Usage

```dart
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
```

## Additional information

Feel free to contribute to the package. 


For more on [super_editor](https://pub.dev/packages/super_editor) visit [Superlist](https://www.superlist.com/).

## Disclaimer
I am not affiliated with Superlist or super editor, I spent the time to write this for a personal project I thought I would share.
