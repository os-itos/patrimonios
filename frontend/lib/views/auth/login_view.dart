import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

class LoginPatrimonio extends StatelessWidget {
  const LoginPatrimonio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 254, 254),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D5DFF),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.white,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  'Patrimônio',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Gestão de Patrimônios Escolares',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w100,
                    color: Color.fromARGB(255, 145, 145, 145),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}