class EventModel {
  final String id;
  final String title;
  final String description;
  final String venue;
  final String startDatetime;
  final String endDatetime;
  final String status;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.venue,
    required this.startDatetime,
    required this.endDatetime,
    required this.status,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      venue: json['venue'] ?? '',
      startDatetime: json['start_datetime'] ?? '',
      endDatetime: json['end_datetime'] ?? '',
      status: json['status'] ?? '',
    );
  }
}