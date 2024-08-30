import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:masterwifi/speedtest2.dart';

class SpeedTest extends StatefulWidget {
  const SpeedTest({Key? key}) : super(key: key);

  @override
  State<SpeedTest> createState() => _SpeedTestState();
}

class _SpeedTestState extends State<SpeedTest> {
  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();
  TestType? _currentTestType;
  bool _testInProgress = false;
  double _downloadRate = 0;
  double _uploadRate = 0;
  String _downloadProgress = '0';
  String _uploadProgress = '0';
  bool _isServerSelectionInProgress = false;

  String? _ip;
  String? _asn;
  String? _isp;

  String _unitText = 'Mbps';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Use a dark gradient as per the image
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Speed Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildTopIndicators(),
            _buildSpeedometer(),
            _buildDownloadUploadProgress(),
            // _buildNetworkInfo(),
            !_testInProgress
                ? ElevatedButton(
                    child: const Text('Start Testing'),
                    onPressed: _startTest,
                  )
                : _buildCancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIndicator('Network latency', '959ms'),
        _buildIndicator('Jitter', '2ms'),
        _buildIndicator('Packet Loss Rate', '---'),
      ],
    );
  }

  Widget _buildIndicator(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4.0),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSpeedometer() {
    Color speedometerColor;

    switch (_currentTestType) {
      case TestType.upload:
        speedometerColor = Colors.green;
        break;
      case TestType.download:
      default:
        speedometerColor = Colors.blue;
        break;
    }

    return Container(
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [speedometerColor, Colors.grey.shade800],
          stops: [0.5, 0.5],
        ),
      ),
      child: Center(
        child: Text(
          '${_currentTestType == TestType.download ? _downloadRate : _uploadRate} $_unitText',
          style: const TextStyle(
              color: Colors.white, fontSize: 32.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDownloadUploadProgress() {
    return Column(
      children: [
        const Text('Download', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 4.0),
        LinearProgressIndicator(
          value: _downloadRate / 1000,
          backgroundColor: Colors.grey.shade800,
          color: Colors.blue,
        ),
        const SizedBox(height: 16.0),
        const Text('Upload', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 4.0),
        LinearProgressIndicator(
          value: _uploadRate / 1000,
          backgroundColor: Colors.grey.shade800,
          color: Colors.green,
        ),
      ],
    );
  }

  // Widget _buildNetworkInfo() {
  //   return Text(
  //     'ZONG 4G/5G', // Replace with dynamic ISP info
  //     style: const TextStyle(color: Colors.white),
  //   );
  // }

  Widget _buildCancelButton() {
    return Column(
      children: [
        const CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton.icon(
            onPressed: () => internetSpeedTest.cancelTest(),
            icon: const Icon(Icons.cancel_rounded),
            label: const Text('Cancel'),
          ),
        ),
      ],
    );
  }

  Future<void> _startTest() async {
    reset();
    await internetSpeedTest.startTesting(
      onStarted: () {
        setState(() => _testInProgress = true);
      },
      onCompleted: (TestResult download, TestResult upload) {
        setState(() {
          _downloadRate = download.transferRate;
          _uploadRate = upload.transferRate;
          _unitText = download.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
          _downloadProgress = '100';
          _uploadProgress = '100';
          _testInProgress = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              downloadSpeed: _downloadRate,
              uploadSpeed: _uploadRate,

              ipAddress: _ip,
              ispName: _isp,
              // Provide actual packet loss rate if available
            ),
          ),
        );
      },
      onProgress: (double percent, TestResult data) {
        setState(() {
          _unitText = data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
          if (data.type == TestType.download) {
            _currentTestType = TestType.download;
            _downloadRate = data.transferRate;
            _downloadProgress = percent.toStringAsFixed(2);
          } else {
            _currentTestType = TestType.upload;
            _uploadRate = data.transferRate;
            _uploadProgress = percent.toStringAsFixed(2);
          }
        });
      },
      onError: (String errorMessage, String speedTestError) {
        setState(() {
          _testInProgress = false;
        });
        // Handle error
      },
      onDefaultServerSelectionInProgress: () {
        setState(() {
          _isServerSelectionInProgress = true;
        });
      },
      onDefaultServerSelectionDone: (Client? client) {
        setState(() {
          _isServerSelectionInProgress = false;
          _ip = client?.ip;
          _asn = client?.asn;
          _isp = client?.isp;
        });
      },
      onCancel: () {
        reset();
      },
    );
  }

  void reset() {
    setState(() {
      _testInProgress = false;
      _downloadRate = 0;
      _uploadRate = 0;
      _downloadProgress = '0';
      _uploadProgress = '0';
      _unitText = 'Mbps';
      _ip = null;
      _asn = null;
      _isp = null;
    });
  }
}
