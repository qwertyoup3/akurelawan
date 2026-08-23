class EventModel {
  final String id;
  final String title;
  final String type;
  final String affectedRegions;
  final String urgencyLevel;
  final String status;
  final String description;

  EventModel({
    required this.id,
    required this.title,
    required this.type,
    required this.affectedRegions,
    required this.urgencyLevel,
    required this.status,
    required this.description,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      affectedRegions: json['affected_regions'] ?? '',
      urgencyLevel: json['urgency_level'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
