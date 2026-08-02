class SearchRequestModel {
  const SearchRequestModel({
    required this.query,
    this.regionId,
    this.minimumPrice,
    this.maximumPrice,
    this.rating,
  });

  final String query;
  final int? regionId;
  final double? minimumPrice;
  final double? maximumPrice;
  final double? rating;

  Map<String, dynamic> toJson() => {
    'query': query.trim(),
    if (regionId != null) 'region_id': regionId,
    if (minimumPrice != null) 'minimum_price': minimumPrice,
    if (maximumPrice != null) 'maximum_price': maximumPrice,
    if (rating != null) 'rating': rating,
  };
}
