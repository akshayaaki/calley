class CallingListModel {
  final String id;
  final String name;
  final List<dynamic> agents;
  final String clientId;
  final int totalCalls;

  CallingListModel({
    required this.id,
    required this.name,
    this.agents = const [],
    required this.clientId,
    this.totalCalls = 50,
  });

  factory CallingListModel.fromJson(Map<String, dynamic> json) {
    return CallingListModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'Calling List',
      agents: json['agents'] ?? [],
      clientId: json['clientId'] ?? '',
      totalCalls: json['totalCalls'] ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'agents': agents,
      'clientId': clientId,
      'totalCalls': totalCalls,
    };
  }
}

