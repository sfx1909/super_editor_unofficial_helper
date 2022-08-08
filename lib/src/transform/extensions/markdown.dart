import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';

extension MarkdownDocument on Document {
  String toMarkdown() => serializeDocumentToMarkdown(this);

  static MutableDocument fromMarkdown(String markdown) =>
      deserializeMarkdownToDocument(markdown);
}
