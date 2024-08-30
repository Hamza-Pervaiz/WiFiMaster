class CustomWiFiNetwork {
  late String ssid;
  String? capabilities;
  final int frequency;
  int? level;
  final String bssid;
  String? ip;

  CustomWiFiNetwork(
      {required this.ssid,
      this.capabilities,
      required this.frequency,
      this.level,
      required this.bssid,
      this.ip});
}
