import 'package:flutter/material.dart';

class VotingScreen extends StatefulWidget {
  final List<String> playerNames;
  final List<String> roles; // роли игроков
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

    // Отладка: печатаем роли игроков
    for (int i = 0; i < _playerNames.length; i++) {
      debugPrint("Игрок: ${_playerNames[i]}, Роль: ${_roles[i]}");
    }
  }

  void _confirmVote(BuildContext context, int index) {
    String player = _playerNames[index];
    String role = _roles[index];

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

              bool wasSpy = role.contains("Шпион");

              // Удаляем игрока и роль
              setState(() {
                _playerNames.removeAt(index);
                _roles.removeAt(index);
              });

              int spiesLeft = _roles.where((r) => r.contains("Шпион")).length;

              if (wasSpy) {
                if (spiesLeft == 0) {
                  // последний шпион → победа мирных
                  widget.onResult(false, player, _playerNames, _roles);
                } else {
                  // ещё остались шпионы → продолжаем
                  widget.onResult(false, player, _playerNames, _roles);
                }
              } else {
                // исключили мирного → победа шпионов
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
              "assets/back.gif",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _playerNames.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.black.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.8),
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      _playerNames[index],
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () => _confirmVote(context, index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
