
import 'content_section_type.dart';

class ContentSection {
  const ContentSection({
    required this.title,
    required this.type,
    required this.items,
    this.itemHeight,
  });

  final String title;
  final ContentSectionType type;
  final List<dynamic> items;

  final double? itemHeight;
}
