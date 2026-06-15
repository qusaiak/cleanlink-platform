
import 'content_section_type.dart';

class ContentSection {
  const ContentSection({
    required this.id,
    required this.title,
    required this.type,
    required this.items,
    this.itemHeight,
  });

  final String id;
  final String title;
  final ContentSectionType type;
  final List<String> items;

  final double? itemHeight;
}
