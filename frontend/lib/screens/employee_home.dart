import 'package:flutter/material.dart';
import '../api_service.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService api = ApiService();

  // 입력 컨트롤러
  final _locController = TextEditingController();
  final _val1Controller = TextEditingController(); // 라돈 or 좌측
  final _val2Controller = TextEditingController(); // TVOC or 우측
  String _resultText = "값을 입력하고 분석 버튼을 누르세요";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 공기질, 레벨기
  }

  void _analyze(String type) async {
    if (_locController.text.isEmpty ||
        _val1Controller.text.isEmpty ||
        _val2Controller.text.isEmpty) {
      setState(() {
        _resultText = "모든 값을 입력해주세요.";
      });
      return;
    }

    double? v1 = double.tryParse(_val1Controller.text);
    double? v2 = double.tryParse(_val2Controller.text);

    if (v1 == null || v2 == null) {
      setState(() {
        _resultText = "숫자 값을 올바르게 입력해주세요.";
      });
      return;
    }

    try {
      final res = await api.sendEquipmentData(
        "emp01",
        type,
        _locController.text,
        v1,
        v2,
      );

      setState(() {
        _resultText = "판정 결과: ${res['status']}\n${res['message']}";
      });
    } catch (e) {
      setState(() {
        _resultText = "서버 연결 오류: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("전문 장비 점검"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "공기질(라돈)"),
            Tab(text: "레벨기(수평)"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildForm("air", "라돈(Bq/m³)", "TVOC"),
          _buildForm("level", "좌측 높이(mm)", "우측 높이(mm)"),
        ],
      ),
    );
  }

  Widget _buildForm(String type, String label1, String label2) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _locController,
            decoration: const InputDecoration(
              labelText: "측정 위치 (예: 거실)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _val1Controller,
                  decoration: InputDecoration(
                    labelText: label1,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _val2Controller,
                  decoration: InputDecoration(
                    labelText: label2,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _analyze(type),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("분석 및 저장"),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _resultText,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _locController.dispose();
    _val1Controller.dispose();
    _val2Controller.dispose();
    super.dispose();
  }
}

