import 'package:flutter/material.dart';
import 'category_selection_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const SpyGame());
}

class SpyGame extends StatelessWidget {
  const SpyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spy Game',
      theme: ThemeData(
        textTheme: GoogleFonts.delaGothicOneTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _controllers = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  bool _deleteMode = false;

  void _addPlayer() {
    final controller = TextEditingController();
    controller.addListener(() {
      setState(() {}); // обновляем экран при каждом вводе
    });
    _controllers.add(controller);
    _listKey.currentState?.insertItem(
      _controllers.length - 1,
      duration: const Duration(milliseconds: 200),
    );
    setState(() {
      _deleteMode = false;
    });
  }

  void _removePlayer(int index) {
    final removedController = _controllers.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildPlayerCard(
        context,
        index,
        animation,
        removedController,
        isRemoving: true,
      ),
      duration: const Duration(milliseconds: 200),
    );
    setState(() {});
  }

  void _toggleDeleteMode() {
    setState(() {
      _deleteMode = !_deleteMode;
    });
  }

  Widget _buildPlayerCard(
    BuildContext context,
    int index,
    Animation<double> animation,
    TextEditingController controller, {
    bool isRemoving = false,
  }) {
    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 0.0,
      child: FadeTransition(
        opacity: animation,
        child: GestureDetector(
          onTap: () {
            if (_deleteMode && !isRemoving) {
              _removePlayer(index);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(35),
              border: _deleteMode
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              enabled: !_deleteMode,
              decoration: const InputDecoration(
                hintText: 'Имя игрока',
                hintStyle: TextStyle(color: Colors.white54, fontSize: 18),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonHeight = 200.0; // большой размер кнопки как в GameSettingsScreen

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background_02.gif',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Spy Game',
                  style: TextStyle(
                    fontSize: 58,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: _deleteMode ? Colors.redAccent : Colors.white,
                        size: 25,
                      ),
                      onPressed: _toggleDeleteMode,
                    ),
                    const SizedBox(width: 50),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white, size: 32),
                      onPressed: _addPlayer,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    initialItemCount: _controllers.length,
                    itemBuilder: (context, index, animation) {
                      return _buildPlayerCard(
                        context,
                        index,
                        animation,
                        _controllers[index],
                      );
                    },
                  ),
                ),
                SizedBox(height: buttonHeight / 2),
              ],
            ),
          ),

          // Кнопка "Далее" как в GameSettingsScreen
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            left: 20,
            right: 20,
            bottom: _controllers.length >= 3 &&
                    _controllers.every((c) => c.text.trim().isNotEmpty)
                ? -100
                : -250,
            child: SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  textStyle: GoogleFonts.delaGothicOne(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategorySelectionScreen(
                        playerCount: _controllers.length,
                        playerNames:
                            _controllers.map((c) => c.text).toList(),
                      ),
                    ),
                  );
                },
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Далее | ${_controllers.length} игроков\n\n\n',
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
}
