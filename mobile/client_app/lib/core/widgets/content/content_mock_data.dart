import 'content_section_type.dart';

/// Mock asset paths used by the listing/grid views until the real API is
/// wired in. Centralised here so both the home/sports content view and the
/// global [AppContentPage] stay in sync.
abstract final class ContentMockData {
  static const _moviePosters = <String>[
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
  ];

  static const _seriesPosters = <String>[
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
  ];

  static const _programPosters = <String>[
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
  ];

  static const _channelPosters = <String>[
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
  ];

  static const _clipPosters = <String>[
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
    'assets/images/test/test.jpg',
  ];

  static List<String> itemsFor(ContentSectionType type, {int count = 12}) {
    final source = switch (type) {
      ContentSectionType.companies => _moviePosters,
      ContentSectionType.services => _seriesPosters,
      ContentSectionType.categories => _programPosters,
      ContentSectionType.regions => _channelPosters,
      ContentSectionType.providers => _clipPosters,
      ContentSectionType.offers => _clipPosters,
    };
    return List.generate(count, (i) => source[i % source.length]);
  }
}
