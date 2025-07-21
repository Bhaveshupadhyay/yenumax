class RemovedDevicesModel{
  final bool isRemoved;
  final String message;


  RemovedDevicesModel({required this.isRemoved, required this.message});

  factory RemovedDevicesModel.fromJson(Map<String, dynamic> json) {
    return RemovedDevicesModel(
      isRemoved: json['isRemoved'],
      message: json['message']
    );
  }
}

