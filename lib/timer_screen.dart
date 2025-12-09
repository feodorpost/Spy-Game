import 'package:flutter/material.dart';
import 'dart:async';
import 'spy_eliminated_screen.dart';
import 'lose_screen.dart';
import 'voting_screen.dart';
import 'victory_screen.dart';

class TimerScreen extends StatefulWidget {
  final int duration; // из настроек
  final List<String> playerNames;
  final List<String> roles; // список ролей для проверки

  const TimerScreen({
    super.key,
    required this.duration,
    required this.playerNames,
    required this.roles,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late int remainingTime;
  Timer? _timer;

  late List<String> _playerNames;
  late List<String> _roles;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.duration;
    _playerNames = List.from(widget.playerNames);
    _roles = List.from(widget.roles);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        // тут можно автоголосование или поражение
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToVoting() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VotingScreen(
          playerNames: _playerNames,
          roles: _roles,
          onResult: (bool spiesWin, String? eliminatedPlayer, List<String> newPlayers, List<String> newRoles) {
            if (spiesWin) {
              // шпионы победили
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoseScreen()),
              );
            } else {
              // обновляем списки игроков и ролей
              setState(() {
                _playerNames = newPlayers;
                _roles = newRoles;
              });

              if (eliminatedPlayer != null) {
                int spiesLeft = _roles.where((r) => r.contains("Шпион")).length;

                if (spiesLeft == 0) {
                  // все шпионы исключены → победа мирных
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const VictoryScreen()),
                  );
                } else {
                  // исключён шпион, но остались ещё → показать экран и вернуться к таймеру
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SpyEliminatedScreen(
                        eliminatedPlayer: eliminatedPlayer,
                        lastSpy: false,
                        eliminatedWasSpy: true,
                        onContinue: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TimerScreen(
                                duration: remainingTime,
                                playerNames: _playerNames,
                                roles: _roles,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/back.gif", fit: BoxFit.cover),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$remainingTime",
                  style: const TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _goToVoting,
                  child: const Text("Голосование"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
