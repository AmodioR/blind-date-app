import 'package:flutter/material.dart';

const _pink = Color(0xFFF13BB7);
const _coral = Color(0xFFFF6F75);
const _orange = Color(0xFFFFA24E);
const _ink = Color(0xFF241F2A);
const _muted = Color(0xFF837B88);
const _surface = Color(0xFFFFF8FA);

const blindDateGradient = LinearGradient(
  colors: [_pink, _coral, _orange],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

class BlindDateV2App extends StatelessWidget {
  const BlindDateV2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlindDate 2.0',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SNPro',
        scaffoldBackgroundColor: _surface,
        colorScheme: ColorScheme.fromSeed(seedColor: _pink),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 34, height: 1.05, fontWeight: FontWeight.w600, color: _ink),
          headlineMedium: TextStyle(fontSize: 28, height: 1.1, fontWeight: FontWeight.w600, color: _ink),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _ink),
          bodyLarge: TextStyle(fontSize: 16, height: 1.45, color: _ink),
          bodyMedium: TextStyle(fontSize: 14, height: 1.4, color: _muted),
        ),
      ),
      home: const V2PreviewShell(),
    );
  }
}

class V2PreviewShell extends StatefulWidget {
  const V2PreviewShell({super.key});

  @override
  State<V2PreviewShell> createState() => _V2PreviewShellState();
}

class _V2PreviewShellState extends State<V2PreviewShell> {
  int index = 0;

  final screens = const [
    HomeV2Screen(),
    BlindChatV2Screen(),
    ProfileV2Screen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 24, offset: Offset(0, 8))],
          ),
          child: NavigationBar(
            height: 58,
            backgroundColor: Colors.transparent,
            elevation: 0,
            indicatorColor: const Color(0xFFFFE4EF),
            selectedIndex: index,
            onDestinationSelected: (value) => setState(() => index = value),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.favorite_border_rounded), selectedIcon: Icon(Icons.favorite_rounded), label: 'Blind Date'),
              NavigationDestination(icon: Icon(Icons.chat_bubble_outline_rounded), selectedIcon: Icon(Icons.chat_bubble_rounded), label: 'Chat'),
              NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profil'),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeV2Screen extends StatelessWidget {
  const HomeV2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset('assets/images/BDV4.png', width: 54, height: 42, fit: BoxFit.contain),
                const Spacer(),
                _CircleButton(icon: Icons.tune_rounded, onTap: () {}),
              ],
            ),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 132,
                    height: 132,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: blindDateGradient,
                      boxShadow: const [BoxShadow(color: Color(0x36F13BB7), blurRadius: 34, offset: Offset(0, 15))],
                    ),
                    child: const Icon(Icons.favorite_rounded, size: 54, color: Colors.white),
                  ),
                  const SizedBox(height: 34),
                  Text('Klar til noget nyt?', style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  const Text(
                    'Ét tryk. Én person. Ingen swipes.\nLær personen at kende før billedet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, height: 1.5, color: _muted),
                  ),
                  const SizedBox(height: 34),
                  GradientButton(label: 'Find en Blind Date', icon: Icons.auto_awesome_rounded, onTap: () {}),
                  const SizedBox(height: 14),
                  const Text('Vi matcher kun, når jeres præferencer passer begge veje.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5, color: _muted)),
                ],
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class BlindChatV2Screen extends StatelessWidget {
  const BlindChatV2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(shape: BoxShape.circle, gradient: blindDateGradient),
                      child: const Icon(Icons.visibility_off_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Din Blind Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _ink)), SizedBox(height: 2), Text('24 år  •  ca. 8 km væk', style: TextStyle(fontSize: 13, color: _muted))])),
                    _CircleButton(icon: Icons.more_horiz_rounded, onTap: () {}),
                  ],
                ),
                const SizedBox(height: 18),
                const Row(children: [Text('Lær hinanden at kende', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _ink)), Spacer(), Text('60%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _pink))]),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(children: [Container(height: 8, color: const Color(0xFFFFE4EC)), FractionallySizedBox(widthFactor: .6, child: Container(height: 8, decoration: const BoxDecoration(gradient: blindDateGradient)))]),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x0F000000)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              children: const [
                _SystemPill(text: 'I er blevet matchet ✨\nStart med at lære hinanden at kende.'),
                SizedBox(height: 24),
                _Bubble(text: 'Hej! Okay det her er lidt mere spændende end at swipe 😅', mine: false),
                _Bubble(text: 'Hahaha ja, jeg føler lidt man faktisk bliver nødt til at snakke nu 😂', mine: true),
                _Bubble(text: 'Præcis! Hvad bruger du egentlig helst en fri weekend på?', mine: false),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    height: 50,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: const Color(0x12000000))),
                    alignment: Alignment.centerLeft,
                    child: const Text('Skriv en besked…', style: TextStyle(color: _muted)),
                  ),
                ),
                const SizedBox(width: 10),
                Container(width: 50, height: 50, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: blindDateGradient), child: const Icon(Icons.arrow_upward_rounded, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileV2Screen extends StatelessWidget {
  const ProfileV2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        children: [
          Row(children: [Text('Din profil', style: Theme.of(context).textTheme.headlineMedium), const Spacer(), _CircleButton(icon: Icons.settings_outlined, onTap: () {})]),
          const SizedBox(height: 30),
          Center(
            child: Stack(
              children: [
                Container(width: 118, height: 118, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: blindDateGradient), child: const Icon(Icons.person_rounded, size: 58, color: Colors.white)),
                Positioned(right: 0, bottom: 0, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0x11000000))), child: const Icon(Icons.edit_rounded, size: 18, color: _pink))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: Text('Patrick, 26', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _ink))),
          const SizedBox(height: 6),
          const Center(child: Text('Holbæk', style: TextStyle(color: _muted))),
          const SizedBox(height: 30),
          const _ProfileCard(icon: Icons.favorite_outline_rounded, title: 'Mine præferencer', subtitle: 'Alder, køn og afstand'),
          const _ProfileCard(icon: Icons.question_answer_outlined, title: 'Mine Blind Date-svar', subtitle: '10 personlige spørgsmål'),
          const _ProfileCard(icon: Icons.shield_outlined, title: 'Tryghed & privatliv', subtitle: 'Blokering, rapportering og sikkerhed'),
        ],
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({super.key, required this.label, required this.onTap, this.icon});
  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Ink(
        height: 58,
        width: double.infinity,
        decoration: BoxDecoration(gradient: blindDateGradient, borderRadius: BorderRadius.circular(28), boxShadow: const [BoxShadow(color: Color(0x28F13BB7), blurRadius: 20, offset: Offset(0, 9))]),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [if (icon != null) ...[Icon(icon, color: Colors.white, size: 20), const SizedBox(width: 9)], Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))]),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(24), child: Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0x0D000000))), child: Icon(icon, color: _ink, size: 21)));
}

class _SystemPill extends StatelessWidget {
  const _SystemPill({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11), decoration: BoxDecoration(color: const Color(0xFFFFEAF2), borderRadius: BorderRadius.circular(18)), child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5, height: 1.4, color: _muted))));
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.mine});
  final String text;
  final bool mine;
  @override
  Widget build(BuildContext context) => Align(alignment: mine ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 12), constraints: const BoxConstraints(maxWidth: 285), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(gradient: mine ? blindDateGradient : null, color: mine ? null : Colors.white, borderRadius: BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20), bottomLeft: Radius.circular(mine ? 20 : 6), bottomRight: Radius.circular(mine ? 6 : 20)), border: mine ? null : Border.all(color: const Color(0x0D000000))), child: Text(text, style: TextStyle(fontSize: 15, height: 1.35, color: mine ? Colors.white : _ink))));
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0x0C000000))), child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFFFEAF2), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: _pink, size: 22)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600, color: _ink)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(fontSize: 13, color: _muted))])), const Icon(Icons.chevron_right_rounded, color: _muted)]));
}
