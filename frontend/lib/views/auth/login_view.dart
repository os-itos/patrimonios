import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

class LoginPatrimonio extends StatelessWidget {
  const LoginPatrimonio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
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
                ),

                Container(
                  width: double.infinity,
                  height: 430,
                  margin: EdgeInsets.only(
                    top: 30,
                  ),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    
                    children: [
                      Text(
                        
                        "Acessar conta",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 25
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        "E-mail Institucional",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14
                        ),
                      ),

                      const SizedBox(height: 5),

                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email",
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.email_outlined),


                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(45, 13, 13, 13),
                              width: 1,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF1D5DFF),
                              width: 3
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Senha",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14
                        ),
                      ),

                      const SizedBox(height: 5),

                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Digite sua senha",
                          fillColor: const Color.fromARGB(255, 241, 8, 8),
                          prefixIcon: const Icon(Icons.lock),


                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(45, 13, 13, 13),
                              width: 1,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF1D5DFF),
                              width: 3
                            ),
                          ),
                        ),
                      ),


                      const SizedBox(height: 30),


                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D5DFF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Entrar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                        
                      Center(
                        child: TextButton(
                          onPressed: () {
                          }, 
                          child: Text(
                            "Esqueci minha senha",
                            style: TextStyle(
                              color: Color(0xFF1D5DFF),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),


                    ],
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