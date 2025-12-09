// import 'package:flutter/material.dart';
// import 'dart:async';

// class TimerScreen extends StatefulWidget {
//   final int timerSeconds;

//   const TimerScreen({super.key, required this.timerSeconds});

//   @override
//   State<TimerScreen> createState() => _TimerScreenState();
// }

// class _TimerScreenState extends State<TimerScreen> {
//   late int remainingSeconds;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     remainingSeconds = widget.timerSeconds;
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (remainingSeconds > 0) {
//         setState(() {
//           remainingSeconds--;
//         });
//       } else {
//         _timer.cancel();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
//     final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/back.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const SizedBox(width: 10),
//                     const Text(
//                       'Таймер',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 Center(
//                   child: Text(
//                     '$minutes:$seconds',
//                     style: const TextStyle(
//                       fontSize: 60,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
