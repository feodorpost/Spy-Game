import 'dart:async';
import 'package:flutter/material.dart';
import 'victory_screen.dart';
import 'lose_screen.dart';

class SpyEliminatedScreen extends StatefulWidget {
  final String eliminatedPlayer;
  final bool lastSpy; // если это последний шпион
  final bool eliminatedWasSpy; // true, если исключённый был шпионом
  final VoidCallback onContinue; // возвращение к таймеру, если шпион не последний

  const SpyEliminatedScreen({
    super.key,
    required this.eliminatedPlayer,
    required this.lastSpy,
    required this.eliminatedWasSpy,
    required this.onContinue,
  });

  @override
  State<SpyEliminatedScreen> createState() => _SpyEliminatedScreenState();
}

class _SpyEliminatedScreenState extends State<SpyEliminatedScreen> {
  int secondsLeft = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // если исключён мирный → сразу экран поражения
    if (!widget.eliminatedWasSpy) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoseScreen()),
        );
      });
    } 
    // если последний шпион → сразу экран победы
    else if (widget.lastSpy) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const VictoryScreen()),
        );
      });
    } 
    // иначе показываем экран с таймером и продолжением
    else {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft <= 1) {
        _timer?.cancel();
        widget.onContinue();
      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // если игрок был мирным или последний шпион, мы уже переходим на экран → можно возвращать пустой контейнер
    if (!widget.eliminatedWasSpy || widget.lastSpy) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: Colors.green[800],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.eliminatedPlayer} был шпионом!",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.onContinue,
                child: Text("Продолжить ($secondsLeft)"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
