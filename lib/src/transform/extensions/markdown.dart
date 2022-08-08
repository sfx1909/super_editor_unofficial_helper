import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';

extension MarkdownDocument on Document {
  ///Convert [Document] to Markdown
  String toMarkdown() => serializeDocumentToMarkdown(this);

  ///Create a [Document] from a Markdown string
  static MutableDocument fromMarkdown(String markdown) =>
      deserializeMarkdownToDocument(markdown);
}
