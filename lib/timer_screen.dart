import 'package:flutter/material.dart';
import 'dart:async';
import 'spy_eliminated_screen.dart';
import 'lose_screen.dart';
import 'voting_screen.dart';
import 'victory_screen.dart';

// Внутренние "стадии" одного и того же экрана.
// Раньше переходы между ними делались через Navigator.push/pushReplacement,
// из-за чего либо плодились дублирующиеся таймеры, либо TimerScreen умирал
// раньше времени и его callback'и переставали работать (mounted == false).
// Теперь это просто переключение того, что рисуется внутри одного и того же
// State — сам TimerScreen (и его Timer) не пересоздаётся все время партии.
enum _Stage { timer, voting, eliminated }

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

  bool _gameEnded = false; // чтобы таймер не перебивал победу/поражение

  _Stage _stage = _Stage.timer;
  String? _eliminatedPlayer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.duration;
    _playerNames = List.from(widget.playerNames);
    _roles = List.from(widget.roles);
    _startTimer(); // таймер запускается один раз и тикает непрерывно всю партию
  }

  // Формат таймера в виде M:SS
  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _gameEnded) {
        timer.cancel();
        return;
      }

      if (remainingTime > 1) {
        setState(() => remainingTime--);
      } else {
        setState(() => remainingTime = 0);
        timer.cancel();
        _endGame(const LoseScreen()); // время вышло = поражение
      }
    });
  }

  // Сброс таймера на исходное время (вызывается при подтверждении кика)
  void _resetTimer() {
    if (!mounted || _gameEnded) return;
    setState(() {
      remainingTime = widget.duration;
    });
  }

  // Единственное место, откуда действительно уходим со всего этого экрана
  // насовсем — на финальный экран победы/поражения.
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

  void _goToVoting() {
    if (_gameEnded) return;
    setState(() => _stage = _Stage.voting);
  }

  void _onVotingResult(
    bool spiesWin,
    String? eliminatedPlayer,
    List<String> newPlayers,
    List<String> newRoles,
  ) {
    if (_gameEnded) return;

    if (spiesWin) {
      // исключили мирного → победа шпионов
      _endGame(const LoseScreen());
      return;
    }

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
        // исключён шпион, но остались ещё → показать экран, потом вернуться к таймеру
        setState(() {
          _eliminatedPlayer = eliminatedPlayer;
          _stage = _Stage.eliminated;
        });
      }
    } else {
      // голосование прошло без исключения → просто назад к таймеру
      setState(() => _stage = _Stage.timer);
    }
  }

  void _continueAfterElimination() {
    if (!mounted || _gameEnded) return;
    setState(() => _stage = _Stage.timer);
  }

  // "Назад" из VotingScreen: не Navigator.pop (это вытолкнуло бы весь
  // TimerScreen из стека, на GameSettingsScreen), а просто возврат к
  // экрану таймера внутри того же самого State.
  void _backToTimerFromVoting() {
    if (!mounted || _gameEnded) return;
    setState(() => _stage = _Stage.timer);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildTimerBody() {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/background.webp", fit: BoxFit.cover),
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

  @override
  Widget build(BuildContext context) {
    switch (_stage) {
      case _Stage.voting:
        return VotingScreen(
          playerNames: _playerNames,
          roles: _roles,
          onResetTimer: _resetTimer,
          onResult: _onVotingResult,
          onBack: _backToTimerFromVoting,
        );
      case _Stage.eliminated:
        return SpyEliminatedScreen(
          eliminatedPlayer: _eliminatedPlayer!,
          lastSpy: false,
          eliminatedWasSpy: true,
          onContinue: _continueAfterElimination,
        );
      case _Stage.timer:
        return _buildTimerBody();
    }
  }
}