class PaymentModel {
  final String email;
  final String link;

  PaymentModel({
    required this.email,
    required this.link,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      email: json['email'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'link': link,
    };
  }
}
