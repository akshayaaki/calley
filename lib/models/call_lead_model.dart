class CallLeadModel {
  final String? firstName;
  final String? lastName;
  final String? title;
  final String phone;
  final List<String> otherPhones;
  final String? email;
  final String? address;
  final String? company;
  final int? age;
  final dynamic zip;
  final String? maritalStatus;
  final String? notes;
  final String? calledAt;
  final String? rescheduledAt;
  final String? createdAt;
  String status; // 'pending', 'called', 'rescheduled'
  final String? agentName;
  final String? agentId;
  final int? duration;
  String? feedback;

  CallLeadModel({
    this.firstName,
    this.lastName,
    this.title,
    required this.phone,
    this.otherPhones = const [],
    this.email,
    this.address,
    this.company,
    this.age,
    this.zip,
    this.maritalStatus,
    this.notes,
    this.calledAt,
    this.rescheduledAt,
    this.createdAt,
    this.status = 'pending',
    this.agentName,
    this.agentId,
    this.duration,
    this.feedback,
  });

  String get fullName {
    final parts = [
      if (title != null && title!.isNotEmpty) title,
      if (firstName != null && firstName!.isNotEmpty) firstName,
      if (lastName != null && lastName!.isNotEmpty) lastName,
    ];
    if (parts.isEmpty) return 'Lead Contact';
    return parts.join(' ');
  }

  factory CallLeadModel.fromJson(Map<String, dynamic> json) {
    List<String> others = [];
    for (int i = 1; i <= 4; i++) {
      final key = 'Other Phone $i';
      if (json.containsKey(key) && json[key] != null) {
        others.add(json[key].toString());
      }
    }

    return CallLeadModel(
      firstName: json['FirstName'],
      lastName: json['LastName'],
      title: json['Title'],
      phone: (json['Phone'] ?? '').toString(),
      otherPhones: others,
      email: json['Email'],
      address: json['Address'],
      company: json['Company'],
      age: json['Age'] is int ? json['Age'] : int.tryParse(json['Age']?.toString() ?? ''),
      zip: json['Zip'],
      maritalStatus: json['MaritalStatus'],
      notes: json['Notes'],
      calledAt: json['calledAt'],
      rescheduledAt: json['rescheduledAt'],
      createdAt: json['createdAt'],
      status: (json['status'] ?? 'pending').toString().toLowerCase(),
      agentName: json['agentName'],
      agentId: json['agentId'],
      duration: json['duration'] is int ? json['duration'] : int.tryParse(json['duration']?.toString() ?? ''),
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Title': title,
      'Phone': phone,
      'Email': email,
      'Address': address,
      'Company': company,
      'Age': age,
      'Zip': zip,
      'MaritalStatus': maritalStatus,
      'Notes': notes,
      'calledAt': calledAt,
      'rescheduledAt': rescheduledAt,
      'createdAt': createdAt,
      'status': status,
      'agentName': agentName,
      'agentId': agentId,
      'duration': duration,
      'feedback': feedback,
    };
  }
}

class CallingListDetailsModel {
  final int pending;
  final int called;
  final int rescheduled;
  final List<CallLeadModel> calls;

  CallingListDetailsModel({
    required this.pending,
    required this.called,
    required this.rescheduled,
    required this.calls,
  });

  int get totalCalls => pending + called + rescheduled;

  factory CallingListDetailsModel.fromJson(Map<String, dynamic> json) {
    final callsList = (json['calls'] as List<dynamic>? ?? [])
        .map((c) => CallLeadModel.fromJson(c as Map<String, dynamic>))
        .toList();

    return CallingListDetailsModel(
      pending: json['pending'] ?? 0,
      called: json['called'] ?? 0,
      rescheduled: json['rescheduled'] ?? 0,
      calls: callsList,
    );
  }

  CallingListDetailsModel copyWith({
    int? pending,
    int? called,
    int? rescheduled,
    List<CallLeadModel>? calls,
  }) {
    return CallingListDetailsModel(
      pending: pending ?? this.pending,
      called: called ?? this.called,
      rescheduled: rescheduled ?? this.rescheduled,
      calls: calls ?? this.calls,
    );
  }
}

