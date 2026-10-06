import 'package:flutter/material.dart';

class AtribuirItem extends StatelessWidget {
  const AtribuirItem({super.key});

  final String status = "Disponível"; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shape: const Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 229, 229, 229),
            width: 1,
          ),
        ),
        title: const Text(
          "Atribuir Item",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 110,
              margin: const EdgeInsets.all(25),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Item a ser atribuído:",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 10),

  Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notebook Dell Latitude 5430",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),

            Text(
              "PAT-2024-0041",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: status == "Disponível"
                ? const Color.fromARGB(120, 102, 255, 117)
                : const Color.fromARGB(100, 255, 100, 100),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: status == "Disponível"
                  ? const Color.fromARGB(255, 50, 169, 80)
                  : const Color.fromARGB(255, 200, 50, 50),
            ),
          ),
        ),
      ],
    ),
  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selecionar Professor Responsável",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: "Selecione um professor",

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
                          width: 2,
                        ),
                      ),
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: "1",
                        child: Text("Thiago Ribeiro"),
                      ),
                      DropdownMenuItem(
                        value: "2",
                        child: Text("Carlos Ribeiro"),
                      ),
                      DropdownMenuItem(
                        value: "3",
                        child: Text("Eduardo Fernandes"),
                      ),
                      DropdownMenuItem(
                        value: "4",
                        child: Text("Maria Clara"),
                      ),
                    ],

                    onChanged: (value) {
                      // Professor selecionado
                    },
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Prazo de Devolução (Opcional)",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "DD/MM/AAAA",

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
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF1D5DFF),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Confirmar Atribuição",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}