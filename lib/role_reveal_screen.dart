import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'timer_screen.dart';

class RoleRevealScreen extends StatefulWidget {
  final int playerCount;
  final int spies;
  final List<String> playerNames;
  final int timerSeconds;
  final List<String> selectedCategories; // передаем выбранные категории

  const RoleRevealScreen({
    super.key,
    required this.playerCount,
    required this.spies,
    required this.playerNames,
    required this.timerSeconds,
    required this.selectedCategories,
  });

  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen>
    with SingleTickerProviderStateMixin {
  late List<String> roles;
  late List<String> words;

  double offsetY = 0;
  late double maxOffset;
  bool isRoleVisible = false;
  int currentPlayer = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  // Картинки для шторки
  final List<String> swipeImages = [
    'assets/role_pics/image1.jpg',
    'assets/role_pics/image2.jpg',
    'assets/role_pics/image3.jpg',
    'assets/role_pics/image4.jpg',
  ];

  // Выбранная картинка для шторки
  late String swipeImage;

  final Map<String, String> categoryFileMap = {
    "Кинематограф": "movies.txt",
    "Знаменитости": "celeb.txt",
    "Локации": "locations.txt", // важно: совпадает с CategorySelectionScreen
    "Страны": "countries.txt",
    "Всё и сразу": "all_in.txt",
  };

  bool get _hasCurrentRole =>
      roles.isNotEmpty &&
      currentPlayer >= 0 &&
      currentPlayer < roles.length;

  @override
  void initState() {
    super.initState();
    roles = [];
    words = [];

    // выбираем случайную картинку для шторки
    swipeImage = swipeImages[Random().nextInt(swipeImages.length)];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.addListener(() {
      setState(() => offsetY = _animation.value);
    });

    _loadWords().then((_) {
      _generateRoles();
      debugPrint("Выбранные категории: ${widget.selectedCategories}");
      debugPrint("Загруженные слова: $words");
    });
  }

  Future<void> _loadWords() async {
    List<String> loadedWords = [];

    for (final category in widget.selectedCategories) {
      final fileName = categoryFileMap[category];
      if (fileName == null) continue;

      final path = 'assets/words_categ/$fileName';
      try {
        final fileContent = await rootBundle.loadString(path);
        final lines = fileContent
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty);
        loadedWords.addAll(lines);
      } catch (e) {
        debugPrint('Ошибка загрузки категории "$category": $e');
      }
    }

    if (loadedWords.isEmpty) {
      debugPrint('! Слова не загружены! Используем дефолтные.');
      loadedWords = [
        "Школа",
        "Больница",
        "Кафе",
        "Аэропорт",
        "Стадион",
        "Библиотека",
        "Тюрьма"
      ];
    }

    words = loadedWords;
  }

  void _generateRoles() {
    if (words.isEmpty) return;

    final random = Random();
    final word = words[random.nextInt(words.length)];

    // все получают слово
    roles = List.filled(widget.playerCount, word);

    // первые N становятся шпионами
    for (int i = 0; i < widget.spies && i < roles.length; i++) {
      roles[i] = "Ты - Шпион";
    }
    roles.shuffle();

    debugPrint("Сгенерированные роли: $roles");
  }

  void _nextPlayer() {
    if (currentPlayer < widget.playerCount - 1) {
      setState(() {
        currentPlayer++;
        offsetY = 0;
        isRoleVisible = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TimerScreen(
            duration: widget.timerSeconds,
            playerNames: widget.playerNames,
            roles: roles,
          ),
        ),
      );
    }
  }

  void _animateTo(double target) {
    _animation = Tween<double>(begin: offsetY, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    maxOffset = MediaQuery.of(context).size.height / 2;

    return Scaffold(
      body: Stack(
        children: [
          // Фон-гифка (будет перекрыта черным, но пусть живет)
          Positioned.fill(
            child: Image.asset(
              'assets/back.gif',
              fit: BoxFit.cover,
            ),
          ),

          // ЧЕРНЫЙ ФОН НА ВЕСЬ ЭКРАН
          Positioned.fill(
            child: Container(color: Colors.black),
          ),

          // БЛОК С РОЛЬЮ + ИКОНКОЙ
          Positioned(
            top: MediaQuery.of(context).size.height / 2 + 100,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: (offsetY / maxOffset).clamp(0.0, 1.0),
              child: Center(
                child: !_hasCurrentRole
                    ? const SizedBox.shrink()
                    : _RoleWithIcon(roleText: roles[currentPlayer]),
              ),
            ),
          ),

          // ШТОРКА
          Transform.translate(
            offset: Offset(0, -offsetY),
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
  setState(() {
    offsetY -= details.primaryDelta! / 2;
    if (offsetY < 0) offsetY = 0;
    if (offsetY > maxOffset) offsetY = maxOffset;

    // один раз «защёлкиваем» появление кнопки
    if (!isRoleVisible && offsetY >= maxOffset * 0.33) {
      isRoleVisible = true;
    }
  });
},
              onVerticalDragEnd: (details) {
                _animateTo(0);
              },
              child: Stack(
                children: [
                  // сама шторка
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(swipeImage),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Text(
                                (currentPlayer >= 0 &&
                                        currentPlayer <
                                            widget.playerNames.length)
                                    ? widget.playerNames[currentPlayer]
                                    : "",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                          const SizedBox(height: 370),
                          Icon(
                            Icons.keyboard_arrow_up,
                            size: 50,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Свайпни вверх",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 35,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),

                  // КНОПКА "СЛЕДУЮЩИЙ ИГРОК"
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: AnimatedOpacity(
                      opacity: isRoleVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed:
                              isRoleVisible && _hasCurrentRole ? _nextPlayer : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 60),
                          ),
                          child: const Text(
                            "Следующий игрок",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Отдельный виджет для роли + иконки (чтобы было чище и безопаснее)
class _RoleWithIcon extends StatelessWidget {
  final String roleText;

  const _RoleWithIcon({required this.roleText});

  @override
  Widget build(BuildContext context) {
    final bool isSpy = roleText == "Ты - Шпион";

    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.black, // чёрный фон под текстом
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            color: isSpy ? Colors.red : Colors.green,
            size: 45,
          ),
          const SizedBox(width: 12),
          Text(
            roleText,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}