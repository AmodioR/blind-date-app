import 'package:flutter/material.dart';

const _pink = Color(0xFFF13BB7);
const _coral = Color(0xFFFF6F75);
const _orange = Color(0xFFFFA24E);
const _ink = Color(0xFF241F2A);
const _muted = Color(0xFF837B88);
const _surface = Color(0xFFFFF8FA);
const _gradient = LinearGradient(colors: [_pink, _coral, _orange]);

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key, required this.onComplete});
  final VoidCallback onComplete;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int step = 0;
  String gender = 'Mand';
  String lookingFor = 'Kvinder';
  RangeValues ageRange = const RangeValues(22, 30);
  double distance = 30;

  void next() {
    if (step == 5) {
      widget.onComplete();
    } else {
      setState(() => step++);
    }
  }

  void back() {
    if (step > 0) setState(() => step--);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _Welcome(onNext: next),
      _SimpleInput(title: 'Hvad skal vi kalde dig?', hint: 'Fornavn', onBack: back, onNext: next),
      _Choice(title: 'Hvad er dit køn?', value: gender, options: const ['Mand', 'Kvinde', 'Andet'], onChanged: (v) => setState(() => gender = v), onBack: back, onNext: next),
      _Choice(title: 'Hvem vil du møde?', value: lookingFor, options: const ['Kvinder', 'Mænd', 'Alle'], onChanged: (v) => setState(() => lookingFor = v), onBack: back, onNext: next),
      _Preferences(ageRange: ageRange, distance: distance, onAgeChanged: (v) => setState(() => ageRange = v), onDistanceChanged: (v) => setState(() => distance = v), onBack: back, onNext: next),
      _Questions(onBack: back, onNext: next),
    ];

    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: Column(
          children: [
            if (step > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                child: Row(
                  children: [
                    IconButton(onPressed: back, icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
                    const Spacer(),
                    Text('${step + 1}/6', style: const TextStyle(color: _muted, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            Expanded(child: pages[step]),
          ],
        ),
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.onNext});
  final VoidCallback onNext;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
        child: Column(
          children: [
            const Spacer(),
            Image.asset('assets/images/BDV4.png', width: 210),
            const SizedBox(height: 34),
            const Text('Mød personen før billedet.', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: _ink)),
            const SizedBox(height: 12),
            const Text('Ingen swipes. Én person ad gangen. Bare en rigtig chance for at lære nogen at kende.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, height: 1.5, color: _muted)),
            const Spacer(),
            _Button(label: 'Kom i gang', onTap: onNext),
          ],
        ),
      );
}

class _SimpleInput extends StatelessWidget {
  const _SimpleInput({required this.title, required this.hint, required this.onBack, required this.onNext});
  final String title;
  final String hint;
  final VoidCallback onBack;
  final VoidCallback onNext;
  @override
  Widget build(BuildContext context) => _StepShell(
        title: title,
        subtitle: 'Det her er det navn, din Blind Date kommer til at se.',
        child: TextField(decoration: InputDecoration(hintText: hint, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(18))),
        onNext: onNext,
      );
}

class _Choice extends StatelessWidget {
  const _Choice({required this.title, required this.value, required this.options, required this.onChanged, required this.onBack, required this.onNext});
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final VoidCallback onBack;
  final VoidCallback onNext;
  @override
  Widget build(BuildContext context) => _StepShell(
        title: title,
        subtitle: 'Det bruges kun til at finde relevante Blind Dates.',
        child: Column(children: options.map((option) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _SelectCard(label: option, selected: value == option, onTap: () => onChanged(option)))).toList()),
        onNext: onNext,
      );
}

class _Preferences extends StatelessWidget {
  const _Preferences({required this.ageRange, required this.distance, required this.onAgeChanged, required this.onDistanceChanged, required this.onBack, required this.onNext});
  final RangeValues ageRange;
  final double distance;
  final ValueChanged<RangeValues> onAgeChanged;
  final ValueChanged<double> onDistanceChanged;
  final VoidCallback onBack;
  final VoidCallback onNext;
  @override
  Widget build(BuildContext context) => _StepShell(
        title: 'Dine præferencer',
        subtitle: 'Du kan altid ændre dem senere.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alder: ${ageRange.start.round()}–${ageRange.end.round()}', style: const TextStyle(fontWeight: FontWeight.w600, color: _ink)),
            RangeSlider(values: ageRange, min: 18, max: 60, divisions: 42, activeColor: _pink, onChanged: onAgeChanged),
            const SizedBox(height: 24),
            Text('Maksimal afstand: ${distance.round()} km', style: const TextStyle(fontWeight: FontWeight.w600, color: _ink)),
            Slider(value: distance, min: 5, max: 100, divisions: 19, activeColor: _pink, onChanged: onDistanceChanged),
          ],
        ),
        onNext: onNext,
      );
}

class _Questions extends StatelessWidget {
  const _Questions({required this.onBack, required this.onNext});
  final VoidCallback onBack;
  final VoidCallback onNext;
  @override
  Widget build(BuildContext context) => _StepShell(
        title: 'Lidt om dig',
        subtitle: 'Svarene bruges senere til at hjælpe din Blind Date med faktisk at lære dig at kende.',
        child: Column(
          children: const [
            _QuestionPreview('Hvad er din perfekte fridag?'),
            _QuestionPreview('Hvad betyder mest for dig i et forhold?'),
            _QuestionPreview('Hvad drømmer du om at opleve en dag?'),
          ],
        ),
        onNext: onNext,
        buttonLabel: 'Færdiggør profil',
      );
}

class _StepShell extends StatelessWidget {
  const _StepShell({required this.title, required this.subtitle, required this.child, required this.onNext, this.buttonLabel = 'Fortsæt'});
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback onNext;
  final String buttonLabel;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: _ink)),
            const SizedBox(height: 10),
            Text(subtitle, style: const TextStyle(fontSize: 14.5, height: 1.45, color: _muted)),
            const SizedBox(height: 32),
            Expanded(child: SingleChildScrollView(child: child)),
            const SizedBox(height: 20),
            _Button(label: buttonLabel, onTap: onNext),
          ],
        ),
      );
}

class _SelectCard extends StatelessWidget {
  const _SelectCard({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: selected ? _pink : const Color(0x0D000000), width: selected ? 1.5 : 1)),
          child: Row(children: [Expanded(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _ink))), Icon(selected ? Icons.check_circle_rounded : Icons.circle_outlined, color: selected ? _pink : _muted)]),
        ),
      );
}

class _QuestionPreview extends StatelessWidget {
  const _QuestionPreview(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0x0D000000))),
        child: Row(children: [Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _ink))), const Icon(Icons.edit_outlined, color: _pink)]),
      );
}

class _Button extends StatelessWidget {
  const _Button({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(gradient: _gradient, borderRadius: BorderRadius.circular(28)),
          child: Center(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))),
        ),
      );
}
