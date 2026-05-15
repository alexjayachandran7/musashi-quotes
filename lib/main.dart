import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MusashiApp());
}

// ─── Data ──────────────────────────────────────────────────────────────────

class Quote {
  final String text;
  final String book;
  const Quote({required this.text, required this.book});
}

const List<Quote> quotes = [
  Quote(
    text: "Today is victory over yourself of yesterday; tomorrow is your victory over lesser men.",
    book: "The Book of Five Rings",
  ),
  Quote(
    text: "Do nothing that is of no use.",
    book: "The Book of Five Rings",
  ),
  Quote(
    text: "You must understand that there is more than one path to the top of the mountain.",
    book: "The Book of Five Rings",
  ),
  Quote(
    text: "Think lightly of yourself and deeply of the world.",
    book: "Dokkōdō",
  ),
  Quote(
    text: "In the void is virtue, and no evil. Wisdom has existence, principle has existence, the Way has existence, spirit is nothingness.",
    book: "The Book of Five Rings",
  ),
  Quote(
    text: "Accept everything just the way it is.",
    book: "Dokkōdō",
  ),
  Quote(
    text: "There is nothing outside of yourself that can ever enable you to get better, stronger, richer, quicker, or smarter.",
    book: "The Book of Five Rings",
  ),
  Quote(
    text: "It may seem difficult at first, but everything is difficult at first.",
    book: "The Book of Five Rings",
  ),
  Quote(
    text: "Never be jealous. Never let yourself be saddened by a separation. Never harbour resentment.",
    book: "Dokkōdō",
  ),
  Quote(
    text: "Know your enemy, know his sword.",
    book: "The Book of Five Rings",
  ),
  Quote(
    text: "The ultimate aim of martial arts is not having to use them.",
    book: "The Book of Five Rings",
  ),
  Quote(
    text: "Perception is strong and sight weak. In strategy it is important to see distant things as if they were close and to take a distanced view of close things.",
    book: "The Book of Five Rings",
  ),
  Quote(
    text: "You should not have a favourite weapon. To become over-familiar with one weapon is as much a fault as not knowing it sufficiently well.",
    book: "The Book of Five Rings",
  ),
  Quote(
    text: "Get beyond love and grief: exist for the good of Man.",
    book: "Dokkōdō",
  ),
  Quote(
    text: "A man cannot understand the art he is studying if he only looks for the end result without taking the time to delve deeply into the reasoning of the study.",
    book: "The Book of Five Rings",
  ),
  Quote(
    text: "The only reason a warrior is alive is to fight, and the only reason a warrior fights is to win.",
    book: "The Book of Five Rings",
  ),
  Quote(
    text: "Respect Buddha and the gods without counting on their help.",
    book: "Dokkōdō",
  ),
  Quote(
    text: "Study strategy over the years and achieve the spirit of the warrior. Today is victory over yourself of yesterday.",
    book: "The Book of Five Rings",
  ),
];

// ─── App ───────────────────────────────────────────────────────────────────

class MusashiApp extends StatelessWidget {
  const MusashiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musashi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF0E0C0B),
          primary: Color(0xFFC8A96E),
          secondary: Color(0xFF5A4E42),
        ),
      ),
      home: const QuotesScreen(),
    );
  }
}

// ─── Screens ───────────────────────────────────────────────────────────────

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _tabIndex = 0;
  Set<int> _favourites = {};
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favourites') ?? [];
    setState(() {
      _favourites = saved.map(int.parse).toSet();
    });
  }

  Future<void> _saveFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favourites',
      _favourites.map((e) => e.toString()).toList(),
    );
  }

  void _toggleFavourite() {
    HapticFeedback.lightImpact();
    setState(() {
      if (_favourites.contains(_currentIndex)) {
        _favourites.remove(_currentIndex);
      } else {
        _favourites.add(_currentIndex);
      }
    });
    _saveFavourites();
  }

  void _goTo(int index) {
    setState(() => _currentIndex = index);
    _animController.reset();
    _animController.forward();
  }

  void _next() {
    if (_currentIndex < quotes.length - 1) {
      _goTo(_currentIndex + 1);
    }
  }

  void _prev() {
    if (_currentIndex > 0) {
      _goTo(_currentIndex - 1);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0C0B),
      body: _tabIndex == 0
          ? _buildQuotesTab()
          : _tabIndex == 1
              ? _buildFavouritesTab()
              : _buildBooksTab(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    const gold = Color(0xFFC8A96E);
    const dim = Color(0xFF3A3430);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0E0C0B),
        border: Border(top: BorderSide(color: Color(0xFF2A2520), width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, '❧', 'Quotes', gold, dim),
              _navItem(1, '♥', 'Saved', gold, dim),
              _navItem(2, '⊞', 'Books', gold, dim),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i, String icon, String label, Color active, Color inactive) {
    final isActive = _tabIndex == i;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _tabIndex = i);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: 20,
              color: isActive ? active : inactive,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.ebGaramond(
              fontSize: 9,
              letterSpacing: 1.5,
              color: isActive ? active : inactive,
            ),
          ),
        ],
      ),
    );
  }

  // ── Quotes Tab ─────────────────────────────────────────────────────────

  Widget _buildQuotesTab() {
    final quote = quotes[_currentIndex];
    final isFav = _favourites.contains(_currentIndex);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Header
            Text(
              'MUSASHI',
              style: GoogleFonts.cinzel(
                fontSize: 14,
                letterSpacing: 5,
                color: const Color(0xFFC8A96E),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 60,
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.transparent,
                  Color(0xFFC8A96E),
                  Colors.transparent,
                ]),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'The Book of Five Rings',
              style: GoogleFonts.ebGaramond(
                fontSize: 11,
                color: const Color(0xFF5A4E42),
                letterSpacing: 1,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),

            // Quote Card
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF131110),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFC8A96E).withOpacity(0.18),
                      width: 0.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\u201C',
                        style: GoogleFonts.cinzel(
                          fontSize: 52,
                          color: const Color(0xFFC8A96E).withOpacity(0.15),
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Center(
                          child: Text(
                            quote.text,
                            style: GoogleFonts.ebGaramond(
                              fontSize: 19,
                              height: 1.75,
                              color: const Color(0xFFE8DCC8),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8A96E).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFC8A96E).withOpacity(0.2),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              quote.book,
                              style: GoogleFonts.ebGaramond(
                                fontSize: 11,
                                color: const Color(0xFFC8A96E),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Text(
                            '— Miyamoto Musashi',
                            style: GoogleFonts.cinzel(
                              fontSize: 9,
                              letterSpacing: 1.5,
                              color: const Color(0xFFC8A96E).withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleBtn(
                  onTap: _prev,
                  child: const Text('←',
                      style: TextStyle(
                          fontSize: 20, color: Color(0xFFC8A96E))),
                  enabled: _currentIndex > 0,
                ),
                Column(
                  children: [
                    _circleBtn(
                      onTap: _toggleFavourite,
                      child: Text(
                        '♥',
                        style: TextStyle(
                          fontSize: 16,
                          color: isFav
                              ? const Color(0xFFC8A96E)
                              : const Color(0xFF5A4E42),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_currentIndex + 1} / ${quotes.length}',
                      style: GoogleFonts.cinzel(
                        fontSize: 10,
                        letterSpacing: 2,
                        color: const Color(0xFF5A4E42),
                      ),
                    ),
                  ],
                ),
                _circleBtn(
                  onTap: _next,
                  child: const Text('→',
                      style: TextStyle(
                          fontSize: 20, color: Color(0xFFC8A96E))),
                  enabled: _currentIndex < quotes.length - 1,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _circleBtn({
    required VoidCallback onTap,
    required Widget child,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF131110),
          border: Border.all(
            color: enabled
                ? const Color(0xFFC8A96E).withOpacity(0.3)
                : const Color(0xFF2A2520),
            width: 0.5,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }

  // ── Favourites Tab ─────────────────────────────────────────────────────

  Widget _buildFavouritesTab() {
    final favList = _favourites.toList()..sort();

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            'SAVED',
            style: GoogleFonts.cinzel(
              fontSize: 14,
              letterSpacing: 5,
              color: const Color(0xFFC8A96E),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (favList.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No saved quotes yet.\nTap ♥ to save a quote.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ebGaramond(
                    fontSize: 16,
                    color: const Color(0xFF5A4E42),
                    fontStyle: FontStyle.italic,
                    height: 1.8,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: favList.length,
                separatorBuilder: (_, __) => Divider(
                  color: const Color(0xFFC8A96E).withOpacity(0.1),
                  height: 1,
                ),
                itemBuilder: (context, i) {
                  final idx = favList[i];
                  final q = quotes[idx];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 8),
                    title: Text(
                      q.text,
                      style: GoogleFonts.ebGaramond(
                        fontSize: 15,
                        color: const Color(0xFFE8DCC8),
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        q.book,
                        style: GoogleFonts.cinzel(
                          fontSize: 9,
                          letterSpacing: 1.5,
                          color: const Color(0xFFC8A96E).withOpacity(0.6),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _currentIndex = idx;
                        _tabIndex = 0;
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // ── Books Tab ──────────────────────────────────────────────────────────

  Widget _buildBooksTab() {
    final books = [
      {
        'title': 'The Book of Five Rings',
        'year': '1645',
        'desc': 'Gorin-no-sho — a text on kenjutsu and the martial arts in general. Written in the last weeks of Musashi\'s life.',
        'count': quotes.where((q) => q.book == 'The Book of Five Rings').length,
      },
      {
        'title': 'Dokkōdō',
        'year': '1645',
        'desc': 'The Way of Walking Alone — a short work written a week before Musashi\'s death. Twenty-one precepts.',
        'count': quotes.where((q) => q.book == 'Dokkōdō').length,
      },
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              'BOOKS',
              style: GoogleFonts.cinzel(
                fontSize: 14,
                letterSpacing: 5,
                color: const Color(0xFFC8A96E),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            ...books.map((b) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF131110),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFC8A96E).withOpacity(0.18),
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        b['title'] as String,
                        style: GoogleFonts.cinzel(
                          fontSize: 13,
                          color: const Color(0xFFC8A96E),
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        b['year'] as String,
                        style: GoogleFonts.cinzel(
                          fontSize: 10,
                          color: const Color(0xFF5A4E42),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    b['desc'] as String,
                    style: GoogleFonts.ebGaramond(
                      fontSize: 14,
                      color: const Color(0xFF9A8C7E),
                      height: 1.7,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${b['count']} quotes included',
                    style: GoogleFonts.cinzel(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      color: const Color(0xFFC8A96E).withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}