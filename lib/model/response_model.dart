class ResponseModel {
  ResponseModel({required this.conversionRate});
  final double conversionRate;
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(conversionRate: json["conversion_rate"] ?? 0);
  }
}
