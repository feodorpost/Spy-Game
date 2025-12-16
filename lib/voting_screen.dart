import 'package:flutter/material.dart';

class VotingScreen extends StatefulWidget {
  final List<String> playerNames;
  final List<String> roles;

  final VoidCallback onResetTimer; // ✅ сброс таймера при подтверждении кика

  final void Function(
    bool spiesWin,
    String? eliminatedPlayer,
    List<String> newPlayers,
    List<String> newRoles,
  ) onResult;

  const VotingScreen({
    super.key,
    required this.playerNames,
    required this.roles,
    required this.onResult,
    required this.onResetTimer,
  });

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  late List<String> _playerNames;
  late List<String> _roles;

  @override
  void initState() {
    super.initState();
    _playerNames = List.from(widget.playerNames);
    _roles = List.from(widget.roles);
  }

  void _confirmVote(BuildContext context, int index) {
    final player = _playerNames[index];
    final role = _roles[index];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Подтверждение"),
        content: Text("Вы хотите исключить $player?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Нет"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // закрыть диалог

              // ✅ СБРОС ТАЙМЕРА по подтверждению кика
              widget.onResetTimer();

              final wasSpy = role.contains("Шпион");

              setState(() {
                _playerNames.removeAt(index);
                _roles.removeAt(index);
              });

              final spiesLeft = _roles.where((r) => r.contains("Шпион")).length;

              if (wasSpy) {
                // убрали шпиона
                widget.onResult(false, player, _playerNames, _roles);
              } else {
                // убрали мирного → победа шпионов
                widget.onResult(true, player, _playerNames, _roles);
              }
            },
            child: const Text("Да"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/background_02.gif",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _playerNames.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.black.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.8),
                            width: 2,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => _confirmVote(context, index),
                          child: Container(
                            height: 90,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _playerNames[index],
                              style: const TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
