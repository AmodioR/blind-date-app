import 'package:flutter/material.dart';

const _pink = Color(0xFFF13BB7);
const _ink = Color(0xFF241F2A);
const _muted = Color(0xFF837B88);
const _surface = Color(0xFFFFF8FA);

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});
  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  RangeValues ages = const RangeValues(22, 32);
  double distance = 40;
  String gender = 'Kvinder';

  @override
  Widget build(BuildContext context) => _Page(
    title: 'Præferencer',
    children: [
      const Text('Jeg søger', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _ink)),
      const SizedBox(height: 12),
      SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'Kvinder', label: Text('Kvinder')),
          ButtonSegment(value: 'Mænd', label: Text('Mænd')),
          ButtonSegment(value: 'Alle', label: Text('Alle')),
        ],
        selected: {gender},
        onSelectionChanged: (value) => setState(() => gender = value.first),
      ),
      const SizedBox(height: 30),
      Row(children: [const Text('Alder', style: TextStyle(fontWeight: FontWeight.w600, color: _ink)), const Spacer(), Text('${ages.start.round()}–${ages.end.round()} år', style: const TextStyle(color: _pink, fontWeight: FontWeight.w600))]),
      RangeSlider(values: ages, min: 18, max: 60, divisions: 42, activeColor: _pink, onChanged: (value) => setState(() => ages = value)),
      const SizedBox(height: 20),
      Row(children: [const Text('Maksimal afstand', style: TextStyle(fontWeight: FontWeight.w600, color: _ink)), const Spacer(), Text('${distance.round()} km', style: const TextStyle(color: _pink, fontWeight: FontWeight.w600))]),
      Slider(value: distance, min: 5, max: 150, divisions: 29, activeColor: _pink, onChanged: (value) => setState(() => distance = value)),
      const SizedBox(height: 14),
      const Text('Et match oprettes kun, hvis I begge passer inden for hinandens præferencer.', style: TextStyle(fontSize: 13, height: 1.45, color: _muted)),
    ],
  );
}

class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({super.key});
  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  bool muted = false;
  @override
  Widget build(BuildContext context) => _Page(
    title: 'Chatindstillinger',
    children: [
      _Tile(icon: Icons.notifications_none_rounded, title: 'Mute notifikationer', trailing: Switch(value: muted, activeColor: _pink, onChanged: (value) => setState(() => muted = value))),
      const SizedBox(height: 18),
      const _Tile(icon: Icons.link_off_rounded, title: 'Afslut Blind Date', subtitle: 'Afslut forbindelsen og gå tilbage til startsiden.'),
      const _Tile(icon: Icons.person_off_outlined, title: 'Skjul denne bruger', subtitle: 'Undgå at blive matchet med samme person igen.'),
      const _Tile(icon: Icons.flag_outlined, title: 'Send feedback om bruger', subtitle: 'Fortæl BlindDate-teamet om et problem.'),
    ],
  );
}

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});
  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool messages = true;
  bool matches = true;
  @override
  Widget build(BuildContext context) => _Page(
    title: 'Indstillinger',
    children: [
      const _Tile(icon: Icons.edit_outlined, title: 'Redigér profil', subtitle: 'Navn, by, billede og profiloplysninger'),
      const _Tile(icon: Icons.question_answer_outlined, title: 'Blind Date-svar', subtitle: 'Redigér dine personlige svar'),
      const SizedBox(height: 18),
      _Tile(icon: Icons.chat_bubble_outline_rounded, title: 'Nye beskeder', trailing: Switch(value: messages, activeColor: _pink, onChanged: (value) => setState(() => messages = value))),
      _Tile(icon: Icons.favorite_border_rounded, title: 'Match & reveal', trailing: Switch(value: matches, activeColor: _pink, onChanged: (value) => setState(() => matches = value))),
      const SizedBox(height: 18),
      const _Tile(icon: Icons.shield_outlined, title: 'Privatliv & sikkerhed'),
      const _Tile(icon: Icons.account_circle_outlined, title: 'Konto'),
    ],
  );
}

class _Page extends StatelessWidget {
  const _Page({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _surface,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          Row(children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)), const SizedBox(width: 4), Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: _ink))]),
          const SizedBox(height: 28),
          ...children,
        ],
      ),
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.title, this.subtitle, this.trailing});
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0x12000000))),
    child: Row(children: [
      Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFFFEAF2), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: _pink, size: 21)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _ink)), if (subtitle != null) ...[const SizedBox(height: 3), Text(subtitle!, style: const TextStyle(fontSize: 12.5, color: _muted))]])),
      trailing ?? const Icon(Icons.chevron_right_rounded, color: _muted),
    ]),
  );
}
