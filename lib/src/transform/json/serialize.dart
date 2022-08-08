import 'package:flutter/widgets.dart';
import 'package:super_editor/super_editor.dart';

///Serialize super_editor [Document] to a [Map]
///
/// Some nodes, metadata and attributions might not be mapped.
Map<String, dynamic> documentToMap(
    ///The super_editor document that will be serialized
    Document document, {

      ///Append a list of keys containing the order of nodes
      ///
      /// This is useful if you are using something like Firebase Firestore with sorts data on creation
      bool appendOrder = false,

      ///Will retain the node id found in the document
      ///
      /// If `false` then nodes will be returned in a list
      bool keepID = true,
    }) {
  assert(!(appendOrder && !keepID),
  'AppendOrder is not available when keepID is false');
  var nodes = keepID ? {} : List.empty(growable: true);
  List<dynamic> order = List.empty(growable: true);

  for (int i = 0; i < document.nodes.length; i++) {
    final node = document.nodes.elementAt(i);
    final id = '\$\$${node.id.replaceAll('-', '_')}';
    order.add(id);
    var data;
    if (node is ImageNode) {
      data = {
        'altText': node.altText,
        'imageUrl': node.imageUrl,
        ..._getMeta(node)
      };
    } else if (node is HorizontalRuleNode) {
      data = _getMeta(node);
    } else if (node is ListItemNode) {
      data = {
        'itemType': node.type.index,
        'indent': node.indent,
        ..._getTextMeta(node),
      };
    } else if (node is ParagraphNode) {
      data = _getTextMeta(node);
    }

    if (nodes is Map) {
      nodes[id] = data;
    } else if (nodes is List) {
      nodes.add(data);
    }
  }

  if (nodes is Map) {
    if (appendOrder) {
      return {
        '\$nodes': nodes,
        '\$order': order,
      };
    } else {
      return nodes as Map<String, dynamic>;
    }
  } else {
    return {
      '\$nodes': nodes,
    };
  }
}

Map<String, dynamic> _getTextMeta<N extends TextNode>(N node) {
  final spans = _getSpans(node.text.spans, node.text.text);
  return {
    'text': node.text.text,
    if (spans.isNotEmpty) 'spans': spans,
    ..._getMeta(node)
  };
}

List<Map<String, String>> _getSpans(AttributedSpans spans, String text) {
  const start = 0;
  final end = text.length;
  return spans
      .getAttributionSpansInRange(
      attributionFilter: (candidate) => true, start: start, end: end)
      .map((span) {
    var out = {
      'type': span.attribution.id,
      'offset': '${span.start}:${span.end}',
    };
    final attribution = span.attribution;
    if (attribution is LinkAttribution) {
      out['url'] = attribution.url.toString();
    }
    return out;
  }).toList();
}

Map<String, dynamic> _getMeta<N extends DocumentNode>(N node) {
  return {
    if (node.metadata.isNotEmpty)
      'metadata': node.metadata.map((key, value) {
        if (value is Attribution) {
          return MapEntry(key, value.id);
        }
        if (value is Map) {
          return MapEntry(
            key,
            value.map((key, value) {
              if (value is EdgeInsets) {
                return MapEntry(
                  key,
                  '${value.left}:${value.top}:${value.right}:${value.bottom}',
                );
              }
              if (value is num && value.isInfinite) {
                return MapEntry(key, 'inf');
              } else {
                return MapEntry(key, value);
              }
            }),
          );
        }
        return MapEntry(key, value);
      }),
    'type': node.runtimeType.toString(),
  };
}
