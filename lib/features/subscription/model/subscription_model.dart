class SubscriptionModel {
  final bool isCustomerExist;
  final bool isSubActive;
  final DateTime startDate;
  final DateTime endDate;
  final String subId;
  final int reasonCode;

  SubscriptionModel({
    required this.isCustomerExist,
    required this.isSubActive,
    required this.startDate,
    required this.endDate,
    required this.subId,
    required this.reasonCode,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      isCustomerExist: json['isCustomerExist'] ?? false,
      isSubActive: json['isSubActive'] ?? false,
      startDate: DateTime.fromMillisecondsSinceEpoch((json['start_date'] ?? 0) * 1000),
      endDate: DateTime.fromMillisecondsSinceEpoch((json['end_date'] ?? 0) * 1000),
      subId: json['subId'] ?? '',
      reasonCode: json['reasonCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isCustomerExist': isCustomerExist,
      'isSubActive': isSubActive,
      'start_date': startDate.millisecondsSinceEpoch ~/ 1000,
      'end_date': endDate.millisecondsSinceEpoch ~/ 1000,
      'subId': subId,
      'reasonCode': reasonCode,
    };
  }
}
