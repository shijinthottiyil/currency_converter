class ExchangeModel {
  ExchangeModel({required this.conversionRates});
  final Map<String, dynamic> conversionRates;

  factory ExchangeModel.fromJson(Map<String, dynamic> json) {
    return ExchangeModel(conversionRates: json["conversion_rates"] ?? {});
  }

  @override
  String toString() {
    return conversionRates.toString();
  }
}
