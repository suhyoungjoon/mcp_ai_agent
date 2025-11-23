import 'package:flutter/material.dart';
import '../api_service.dart';
import 'resident_home.dart';
import 'employee_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService api = ApiService();
  final TextEditingController _idController = TextEditingController();

  void _handleLogin(BuildContext context, String role) async {
    if (_idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ID를 입력해주세요.")),
      );
      return;
    }

    try {
      final res = await api.login(_idController.text, role);
      if (res['allow'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['msg'])),
        );
        if (role == 'resident') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResidentHome(daysLeft: res['days_left'] ?? 3),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EmployeeHome()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("접속불가: ${res['msg']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("서버 연결 오류: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "INSIGHT EYE",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: "ID/전화번호",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _handleLogin(context, 'resident'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("입주자 로그인 (3일 한정)"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _handleLogin(context, 'employee'),
                child: const Text("직원/관리자 로그인"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}

