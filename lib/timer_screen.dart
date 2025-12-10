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
    if (!mounted) {
      timer.cancel();
      return;
    }

    if (remainingTime > 1) {
      setState(() {
        remainingTime--;
      });
    } else {
      // остаётся 1 секунда → показываем 0 и поражение
      setState(() {
        remainingTime = 0;
      });
      timer.cancel();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoseScreen(),
        ),
      );
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
            child: Image.asset("assets/background_02.gif", fit: BoxFit.cover),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$remainingTime",
                  style: const TextStyle(fontSize: 100, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                SizedBox(
  width: 260,
  height: 70,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      // Увеличиваем кнопку, но НЕ трогаем textStyle
      padding: EdgeInsets.zero,
    ),
    onPressed: _goToVoting,
    child: const Text(
      "Голосование",
      style: TextStyle(
        fontSize: 28,        // увеличиваем размер
        fontWeight: FontWeight.bold,
        // НЕ задаём шрифт! → GoogleFonts применит автоматически
      ),
    ),
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
