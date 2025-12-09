import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'role_reveal_screen.dart';

class GameSettingsScreen extends StatefulWidget {
  final int playerCount;
  final List<String> playerNames;
  final List<String> selectedCategories;

  const GameSettingsScreen({
    super.key,
    required this.playerCount,
    required this.playerNames,
    required this.selectedCategories,
  });

  @override
  State<GameSettingsScreen> createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen> {
  int spies = 1;
  int timerSeconds = 120;

  @override
  Widget build(BuildContext context) {
    final maxSpies = (widget.playerCount * 0.4).floor().clamp(1, 20);

    return Scaffold(
      body: Stack(
        children: [
          // фон
          Positioned.fill(
            child: Image.asset(
              'assets/back.gif',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Настройки игры',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildSettingCard(
                        title: 'Количество \nшпионов',
                        value: spies.toString(),
                        onIncrement: () {
                          if (spies < maxSpies) setState(() => spies++);
                        },
                        onDecrement: () {
                          if (spies > 1) setState(() => spies--);
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildSettingCard(
                        title: 'Таймер',
                        value:
                            '${(timerSeconds ~/ 60).toString().padLeft(2, '0')}:${(timerSeconds % 60).toString().padLeft(2, '0')}',
                        onIncrement: () => setState(() => timerSeconds += 30),
                        onDecrement: () {
                          if (timerSeconds > 30) setState(() => timerSeconds -= 30);
                        },
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Кнопка "Играть" в стиле HomeScreen
          Positioned(
            left: 20,
            right: 20,
            bottom: -100,
            child: SizedBox(
  width: double.infinity,
  height: 200,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 40), // обнуляем вертикальные паддинги
      textStyle: GoogleFonts.delaGothicOne(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoleRevealScreen(
            playerCount: widget.playerCount,
            spies: spies,
            playerNames: widget.playerNames,
            timerSeconds: timerSeconds,
            selectedCategories: widget.selectedCategories,
          ),
        ),
      );
    },
    child: Align(
      alignment: Alignment.topCenter, // прижимаем текст к верху кнопки
      child: Padding(
        padding: const EdgeInsets.only(top: 30), // небольшой отступ сверху
        child: Text(
          "Играть | ${widget.selectedCategories.length} категорий\n\n\n",
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ),
),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white54, width: 3),
        color: const Color.fromRGBO(0, 0, 0, 0.3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: onDecrement,
                  icon: const Icon(Icons.remove, color: Colors.white)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              IconButton(
                  onPressed: onIncrement,
                  icon: const Icon(Icons.add, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
