import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const DokkodoApp());
}

class Precept {
  final int number;
  final String text;
  final String japanese;
  final String reflection;
  const Precept({required this.number, required this.text, required this.japanese, required this.reflection});
}

const List<Precept> precepts = [
  Precept(number: 1, text: "Accept everything just the way it is.", japanese: "物事をあるがままに受け入れよ。", reflection: "Do not resist reality. Flow with what is."),
  Precept(number: 2, text: "Do not seek pleasure for its own sake.", japanese: "快楽をそれ自体のために求めるな。", reflection: "Pleasure pursued blindly becomes a chain."),
  Precept(number: 3, text: "Do not, under any circumstances, depend on a partial feeling.", japanese: "いかなる場合も、一時の感情に頼るな。", reflection: "Act from clarity, never from impulse alone."),
  Precept(number: 4, text: "Think lightly of yourself and deeply of the world.", japanese: "自分を軽く思い、世界を深く思え。", reflection: "Ego is the enemy of wisdom."),
  Precept(number: 5, text: "Be detached from desire your whole life long.", japanese: "生涯、欲望から離れよ。", reflection: "Want nothing. Then nothing can hold you."),
  Precept(number: 6, text: "Do not regret what you have done.", japanese: "自分のしたことを後悔するな。", reflection: "Every action was your truth in that moment."),
  Precept(number: 7, text: "Never be jealous.", japanese: "嫉妬するな。", reflection: "Jealousy is a confession of inadequacy."),
  Precept(number: 8, text: "Never let yourself be saddened by a separation.", japanese: "別れによって悲しむな。", reflection: "All things are impermanent. Let them go."),
  Precept(number: 9, text: "Resentment and complaint are appropriate neither for oneself nor others.", japanese: "怨みと不平は、自他ともにふさわしくない。", reflection: "Complaining changes nothing. Action changes everything."),
  Precept(number: 10, text: "Do not let yourself be guided by the feeling of lust or love.", japanese: "色欲や愛欲の感情に導かれるな。", reflection: "Feel deeply, but let reason hold the reins."),
  Precept(number: 11, text: "In all things, have no preferences.", japanese: "何事においても、好みを持つな。", reflection: "Preferences create attachment. Attachment creates suffering."),
  Precept(number: 12, text: "Be indifferent to where you live.", japanese: "住む場所にこだわるな。", reflection: "Home is within. Not a place."),
  Precept(number: 13, text: "Do not pursue the taste of good food.", japanese: "美食を追い求めるな。", reflection: "Eat to live. Do not live to eat."),
  Precept(number: 14, text: "Do not hold on to possessions you no longer need.", japanese: "不要な所有物にしがみつくな。", reflection: "What you own ends up owning you."),
  Precept(number: 15, text: "Do not act following customary beliefs.", japanese: "慣習的な信念に従って行動するな。", reflection: "Question everything. Think for yourself."),
  Precept(number: 16, text: "Do not collect weapons or practice with weapons beyond what is useful.", japanese: "有用な範囲を超えて武器を集めるな。", reflection: "Master what matters. Discard the rest."),
  Precept(number: 17, text: "Do not fear death.", japanese: "死を恐れるな。", reflection: "A life lived in fear of death is no life at all."),
  Precept(number: 18, text: "Do not seek to possess either goods or fiefs for your old age.", japanese: "老後のために財を求めるな。", reflection: "Live fully now. The future is not promised."),
  Precept(number: 19, text: "Respect Buddha and the gods without counting on their help.", japanese: "仏や神を敬え、しかしその助けを当てにするな。", reflection: "Honor the sacred. But forge your own path."),
  Precept(number: 20, text: "You may abandon your own body but you must preserve your honour.", japanese: "身を捨てても、名誉を守れ。", reflection: "Character outlives the flesh."),
  Precept(number: 21, text: "Never stray from the Way.", japanese: "道より外れるな。", reflection: "Stay true. Always."),
];

const _black = Color(0xFF000000);
const _cardBg = Color(0xFF0A0A0A);
const _white = Color(0xFFFFFFFF);
const _gray = Color(0xFF888888);
const _border = Color(0xFF222222);
const _mono = 'Courier New';

class DokkodoApp extends StatelessWidget {
  const DokkodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dokkodo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _black,
        colorScheme: const ColorScheme.dark(surface: _black, primary: _white),
        fontFamily: _mono,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _tabIndex = 0;

  void _goTo(int index) => setState(() => _currentIndex = index);
  void _next() { if (_currentIndex < precepts.length - 1) _goTo(_currentIndex + 1); }
  void _prev() { if (_currentIndex > 0) _goTo(_currentIndex - 1); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: _tabIndex == 0 ? _buildPreceptsTab() : _buildAboutTab(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _black,
        border: Border(top: BorderSide(color: _border, width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, 'PRECEPTS'),
              _navItem(1, 'ABOUT'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i, String label) {
    final isActive = _tabIndex == i;
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); setState(() => _tabIndex = i); },
      child: Text(label, style: TextStyle(fontFamily: _mono, fontSize: 10, letterSpacing: 2, color: isActive ? _white : _gray)),
    );
  }

  Widget _buildPreceptsTab() {
    final precept = precepts[_currentIndex];

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text('DOKKODO', style: TextStyle(fontFamily: _mono, fontSize: 13, letterSpacing: 6, color: _white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(width: 40, height: 0.5, color: _gray),
          const SizedBox(height: 8),
          const Text('THE WAY OF WALKING ALONE', style: TextStyle(fontFamily: _mono, fontSize: 10, letterSpacing: 2, color: _gray)),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Container(
                  key: ValueKey(_currentIndex),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _border, width: 0.5),
                  ),
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PRECEPT ${precept.number} OF 21',
                        style: const TextStyle(fontFamily: _mono, fontSize: 10, letterSpacing: 3, color: _gray)),
                      const SizedBox(height: 24),
                      Expanded(
                        child: SingleChildScrollView(child: _buildQuoteText(precept.text)),
                      ),
                      const SizedBox(height: 20),
                      Text(precept.japanese, style: const TextStyle(fontFamily: _mono, fontSize: 12, height: 2, color: _gray, letterSpacing: 3)),
                      const SizedBox(height: 20),
                      Container(width: 32, height: 0.5, color: _gray),
                      const SizedBox(height: 20),
                      Text(precept.reflection, style: const TextStyle(fontFamily: _mono, fontSize: 13, height: 1.8, color: _gray)),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text('— MIYAMOTO MUSASHI, 1645',
                          style: TextStyle(fontFamily: _mono, fontSize: 9, letterSpacing: 2, color: _gray)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navBtn(icon: '←', onTap: _prev, enabled: _currentIndex > 0),
                Text('${_currentIndex + 1} / ${precepts.length}',
                  style: const TextStyle(fontFamily: _mono, fontSize: 9, letterSpacing: 2, color: _gray)),
                _navBtn(icon: '→', onTap: _next, enabled: _currentIndex < precepts.length - 1),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildQuoteText(String text) {
    final words = text.toUpperCase().split(' ');
    final spans = <InlineSpan>[];
    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      if (word.isEmpty) continue;
      spans.add(TextSpan(
        text: word[0],
        style: const TextStyle(fontFamily: _mono, fontSize: 28, fontWeight: FontWeight.bold, color: _white, letterSpacing: 1.5),
      ));
      if (word.length > 1) {
        spans.add(TextSpan(
          text: word.substring(1),
          style: const TextStyle(fontFamily: _mono, fontSize: 18, fontWeight: FontWeight.bold, color: _white, letterSpacing: 1.5),
        ));
      }
      if (i < words.length - 1) {
        spans.add(const TextSpan(text: ' ', style: TextStyle(fontSize: 18)));
      }
    }
    return RichText(text: TextSpan(children: spans));
  }

  Widget _navBtn({required String icon, required VoidCallback onTap, bool enabled = true}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _black,
          border: Border.all(color: enabled ? _gray : _border, width: 0.5),
        ),
        child: Center(child: Text(icon, style: TextStyle(fontFamily: _mono, fontSize: 18, color: enabled ? _white : _gray))),
      ),
    );
  }

  Widget _buildAboutTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Center(child: Text('ABOUT', style: TextStyle(fontFamily: _mono, fontSize: 11, letterSpacing: 5, color: _white, fontWeight: FontWeight.bold))),
            const SizedBox(height: 32),
            const Text('MIYAMOTO MUSASHI', style: TextStyle(fontFamily: _mono, fontSize: 11, letterSpacing: 2, color: _white)),
            const SizedBox(height: 12),
            const Text('Miyamoto Musashi (1584-1645) was a Japanese swordsman, philosopher, and ronin. Widely considered the greatest swordsman who ever lived, he was undefeated in over 61 duels.',
              style: TextStyle(fontFamily: _mono, fontSize: 13, color: _gray, height: 1.9)),
            const SizedBox(height: 28),
            const Text('DOKKODO', style: TextStyle(fontFamily: _mono, fontSize: 11, letterSpacing: 2, color: _white)),
            const SizedBox(height: 12),
            const Text('Written in 1645, one week before his death, Dokkodo contains 21 precepts Musashi left for his most devoted student, Terao Magonojo.',
              style: TextStyle(fontFamily: _mono, fontSize: 13, color: _gray, height: 1.9)),
            const SizedBox(height: 12),
            const Text('These are not motivational quotes. They are the distilled truth of a man who had faced death over sixty times and spent his life in relentless pursuit of the Way.',
              style: TextStyle(fontFamily: _mono, fontSize: 13, color: _gray, height: 1.9)),
            const SizedBox(height: 40),
            const Center(child: Text('道より外れるな。', style: TextStyle(fontSize: 20, color: _white, letterSpacing: 4))),
            const SizedBox(height: 10),
            const Center(child: Text('NEVER STRAY FROM THE WAY.', style: TextStyle(fontFamily: _mono, fontSize: 10, color: _gray, letterSpacing: 2))),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
