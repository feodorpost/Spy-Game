import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game_settings_screen.dart';


class CategorySelectionScreen extends StatefulWidget {
  final int playerCount;
  final List<String> playerNames;

  const CategorySelectionScreen({
    super.key,
    required this.playerCount,
    required this.playerNames,
  });

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final List<Map<String, String>> categories = [
    {'id': '1', 'category': 'Кинематограф', 'image': 'assets/categ1.png'},
    {'id': '2', 'category': 'Знаменитости', 'image': 'assets/categ2.png'},
    {'id': '3', 'category': 'Локации', 'image': 'assets/categ3.png'},
    {'id': '4', 'category': 'Страны', 'image': 'assets/categ4.png'},
    {'id': '5', 'category': 'Всё и сразу', 'image': 'assets/categ5.png'},
  ];

  final Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    final buttonHeight = 200.0; // такой же как в HomeScreen

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/back.gif',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Выберите категории \n(${widget.playerCount} игроков)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 5,
                                color: Colors.black,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 20,
                      childAspectRatio: 4.0,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = selectedIndexes.contains(index);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (category['category'] == 'Всё и сразу') {
                              selectedIndexes.clear();
                              selectedIndexes.add(index);
                            } else {
                              selectedIndexes.removeWhere(
                                  (i) => categories[i]['category'] == 'Всё и сразу');
                              if (isSelected) {
                                selectedIndexes.remove(index);
                              } else {
                                selectedIndexes.add(index);
                              }
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected
                                  ? const Color.fromARGB(255, 230, 230, 230)
                                  : Colors.white54,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color.fromARGB(255, 230, 230, 230)
                                          .withOpacity(0.6),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                            image: DecorationImage(
                              image: AssetImage(category['image']!),
                              fit: BoxFit.cover,
                              colorFilter: isSelected
                                  ? null
                                  : ColorFilter.mode(
                                      Colors.black.withOpacity(0),
                                      BlendMode.darken,
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Кнопка "Далее" в стиле HomeScreen / GameSettingsScreen
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            left: 20,
            right: 20,
            bottom: selectedIndexes.isNotEmpty ? -100 : -250,
            child: SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  textStyle: GoogleFonts.delaGothicOne(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: selectedIndexes.isNotEmpty
                    ? () {
                        final selectedCategories = selectedIndexes
                            .map((i) => categories[i]['category']!)
                            .toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameSettingsScreen(
                              playerCount: widget.playerCount,
                              playerNames: widget.playerNames,
                              selectedCategories: selectedCategories,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Далее | ${selectedIndexes.length} категория(ей)\n\n\n',
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
