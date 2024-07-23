import 'package:flutter/widgets.dart';
import 'package:super_editor/super_editor.dart';

///Deserialize a [Map] into a super_editor [MutableDocument]
///
/// Some nodes, metadata and attributions might not be mapped.
MutableDocument mapToDocument(Map<String, dynamic> map) {
  bool hasOrder = map.containsKey('\$order');
  bool hasNodes = map.containsKey('\$nodes');

  var nodes = hasNodes ? map['\$nodes'] : map;

  if (hasOrder && nodes is Map) {
    final List order = map['\$order'];
    Map<String, dynamic> tempNodes = {};
    for (var i = 0; i < order.length; i++) {
      final orderItem = order.elementAt(i).toString();

      tempNodes[orderItem] = nodes[orderItem];
    }

    if (tempNodes.length != nodes.length) {
      for (var i = 0; i < nodes.length; i++) {
        final node = nodes.entries.elementAt(i);
        tempNodes.putIfAbsent(node.key, () => node.value);
      }
    }
    nodes = tempNodes;
  }

  if (nodes is List) {
    nodes = nodes.asMap().map((key, value) => MapEntry('$key', value));
  }

  List<DocumentNode>? content = List.empty(growable: true);

  for (final node in (nodes as Map<String, dynamic>).entries) {
    final key = node.key;
    final value = node.value;
    final id = key.startsWith('\$\$')
        ? key.replaceAll('\$\$', '').replaceAll('_', '-')
        : DocumentEditor.createNodeId();

    if (value is! Map<String, dynamic>) break;

    final nodeType = value['type'];

    switch (nodeType) {
      case 'ParagraphNode':
        content.add(
          ParagraphNode(
            id: id,
            text: AttributedText(value['text'], _setSpans(value['spans'])),
            metadata: _setMeta(value['metadata']),
          ),
        );
        break;
      case 'HorizontalRuleNode':
        content.add(
          HorizontalRuleNode(
            id: id,
          ),
        );
        break;
      case 'ImageNode':
        content.add(
          ImageNode(
            id: id,
            imageUrl: value['imageUrl'],
            altText: value['altText'],
            metadata: _setMeta(value['metadata']),
          ),
        );
        break;
      case 'ListItemNode':
        content.add(
          ListItemNode(
            id: id,
            itemType: ListItemType.values.elementAt(value['itemType']),
            indent: value['indent'],
            text: AttributedText(value['text'], _setSpans(value['spans'])),
            metadata: _setMeta(value['metadata']),
          ),
        );
        break;
      default:
        break;
    }
  }

  return MutableDocument(nodes: content);
}

AttributedSpans? _setSpans(List<dynamic>? spans) {
  if (spans == null || spans.isEmpty) {
    return null;
  }

  List<SpanMarker> attributions = List.empty(growable: true);

  for (final span in spans) {
    if (span is Map) {
      final offset = span['offset'];
      if (offset is! String?) {
        break;
      }
      final start = offset?.split(':').first;
      final end = offset?.split(':').last;
      final type = span['type'];

      if (type == null || start == null || end == null) {
        break;
      }
      late Attribution attribution;
      switch (type) {
        case 'link':
          attribution = LinkAttribution(url: Uri.parse(span['url'] ?? ''));
          break;
        default:
          attribution = NamedAttribution(type);
          break;
      }
      attributions.addAll([
        SpanMarker(
          attribution: attribution,
          offset: int.parse(start),
          markerType: SpanMarkerType.start,
        ),
        SpanMarker(
          attribution: attribution,
          offset: int.parse(end),
          markerType: SpanMarkerType.end,
        ),
      ]);
    }
  }

  if (attributions.isEmpty) return null;
  return AttributedSpans(attributions: attributions);
}

Map<String, dynamic>? _setMeta(Map<String, dynamic>? meta) {
  if (meta == null) {
    return null;
  }

  dynamic blockType = meta['blockType'] as String?;

  return {
    ...meta.map((key, value) {
      if (value is Map) {
        return MapEntry(
          key,
          value.map((key, value) {
            if (key == 'width' && value == 'inf') {
              return MapEntry(key, double.infinity);
            } else if (value is String && value.split(':').length == 4) {
              final ltrb = value
                  .split(':')
                  .map(
                    (e) => double.tryParse(e),
                  )
                  .toList();
              return MapEntry(
                key,
                EdgeInsets.fromLTRB(
                  ltrb.elementAt(0) ?? 0,
                  ltrb.elementAt(1) ?? 0,
                  ltrb.elementAt(2) ?? 0,
                  ltrb.elementAt(3) ?? 0,
                ),
              );
            }
            return MapEntry(key, value);
          }),
        );
      }
      return MapEntry(key, value);
    }),
    if (blockType != null) 'blockType': NamedAttribution(blockType),
  };
}
