import 'package:flutter/material.dart';
import 'dart:async';
import 'spy_eliminated_screen.dart';
import 'lose_screen.dart';
import 'voting_screen.dart';
import 'victory_screen.dart';

class TimerScreen extends StatefulWidget {
  final int duration; // из настроек (в секундах)
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

  bool _gameEnded = false; // ✅ чтобы таймер не перебивал победу/поражение

  @override
  void initState() {
    super.initState();
    remainingTime = widget.duration;
    _playerNames = List.from(widget.playerNames);
    _roles = List.from(widget.roles);
    _startTimer();
  }

  // ✅ Формат таймера в виде M:SS
  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_gameEnded) {
        timer.cancel();
        return;
      }

      if (remainingTime > 1) {
        setState(() => remainingTime--);
      } else {
        setState(() => remainingTime = 0);
        timer.cancel();

        // ✅ время вышло = поражение, но не перебиваем если игра уже завершена
        _endGame(const LoseScreen());
      }
    });
  }

  // ✅ СБРОС таймера на исходное время (вызываем при подтверждении кика)
  void _resetTimer() {
    if (!mounted || _gameEnded) return;
    setState(() {
      remainingTime = widget.duration;
    });
  }

  void _endGame(Widget screen) {
    if (_gameEnded) return;
    _gameEnded = true;

    _timer?.cancel();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => screen),
      (route) => route.isFirst, // оставляем только "главное меню" внизу стека
    );
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
          onResetTimer: _resetTimer, // ✅ передали колбэк на сброс
          onResult: (
            bool spiesWin,
            String? eliminatedPlayer,
            List<String> newPlayers,
            List<String> newRoles,
          ) {
            if (!mounted || _gameEnded) return;

            if (spiesWin) {
              // исключили мирного → победа шпионов
              _endGame(const LoseScreen());
              return;
            }

            // обновляем списки игроков и ролей
            setState(() {
              _playerNames = newPlayers;
              _roles = newRoles;
            });

            if (eliminatedPlayer != null) {
              final spiesLeft = _roles.where((r) => r.contains("Шпион")).length;

              if (spiesLeft == 0) {
                // все шпионы исключены → победа мирных
                _endGame(const VictoryScreen());
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
                        if (!mounted || _gameEnded) return;

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
                  _formatTime(remainingTime),
                  style: const TextStyle(
                    fontSize: 100,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 260,
                  height: 70,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: _goToVoting,
                    child: const Text(
                      "Голосование",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
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
