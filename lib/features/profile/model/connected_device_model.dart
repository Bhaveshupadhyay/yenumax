class ConnectedDevicesModel{
  final String msg;
  final int reasonCode;

  final List<DeviceModel> devices;

  ConnectedDevicesModel({required this.msg, required this.reasonCode, required this.devices});

  factory ConnectedDevicesModel.fromJson(Map<String, dynamic> json) {
    return ConnectedDevicesModel(
      msg: json['message'],
      reasonCode: json['reasonCode'],
      devices: (json['result'] as List)
          .map((deviceJson) => DeviceModel.fromJson(deviceJson))
          .toList(),
    );
  }
}

class DeviceModel {
  final int userId;
  final String deviceId;
  final String? name;
  final String? imageUrl;

  DeviceModel({
    required this.userId,
    required this.deviceId,
    this.name,
    this.imageUrl,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      userId: json['user_id'],
      deviceId: json['device_id'],
      name: json['device_name'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'device_id': deviceId,
      'name': name,
      'image_url': imageUrl,
    };
  }
}
