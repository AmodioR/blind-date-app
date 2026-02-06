import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/matches/match_model.dart';
import '../data/matches/remote_matches_repository.dart';
import '../theme/app_colors.dart';

class MatchProfileScreen extends StatefulWidget {
  final String matchId;
  final String name;
  final int age;

  const MatchProfileScreen({
    super.key,
    required this.matchId,
    required this.name,
    required this.age,
  });

  @override
  State<MatchProfileScreen> createState() => _MatchProfileScreenState();
}

class _MatchProfileScreenState extends State<MatchProfileScreen> {
  final _repository = RemoteMatchesRepository();
  StreamSubscription<({int myCount, int theirCount})>? _countsSubscription;
  RealtimeChannel? _matchChannel;
  String? _currentUserId;

  MatchModel? _match;
  int _myCount = 0;
  int _theirCount = 0;
  bool _isUnlocking = false;

  double get _unlockProgress {
    final minimumCount = _myCount < _theirCount ? _myCount : _theirCount;
    return (minimumCount / 10).clamp(0.0, 1.0).toDouble();
  }

  @override
  void initState() {
    super.initState();
    _subscribeToMatchCounts();
    _loadInitialMatch();
    _subscribeToMatchUpdates();
  }

  @override
  void dispose() {
    _countsSubscription?.cancel();
    if (_matchChannel != null) {
      Supabase.instance.client.removeChannel(_matchChannel!);
      _matchChannel = null;
    }
    super.dispose();
  }

  void _subscribeToMatchCounts() {
    _countsSubscription = _repository.watchMessageCounts(widget.matchId).listen((counts) {
      if (!mounted) {
        return;
      }
      setState(() {
        _myCount = counts.myCount;
        _theirCount = counts.theirCount;
        _match = _match?.copyWith(myCount: _myCount, theirCount: _theirCount);
      });
    });
  }

  Future<void> _loadInitialMatch() async {
    final match = await _repository.getMatch(widget.matchId);
    if (!mounted) {
      return;
    }

    setState(() {
      _match = match?.copyWith(myCount: _myCount, theirCount: _theirCount);
    });
  }

  void _subscribeToMatchUpdates() {
    if (_matchChannel != null) {
      return;
    }

    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) {
      return;
    }
    _currentUserId = user.id;

    _matchChannel = client
        .channel('match:${widget.matchId}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'matches',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: widget.matchId,
          ),
          callback: (payload) {
            if (!mounted) {
              return;
            }

            _applyRealtimeMatchUpdate(payload.newRecord);
          },
        )
        .subscribe();
  }

  void _applyRealtimeMatchUpdate(Map<String, dynamic> row) {
    final currentUserId = _currentUserId;
    if (currentUserId == null) {
      return;
    }

    final previous = _match;
    final userA = row['user_a']?.toString() ?? previous?.userA ?? '';
    final userB = row['user_b']?.toString() ?? previous?.userB ?? '';

    final isUserA = currentUserId == userA || (currentUserId != userB && previous != null && currentUserId == previous.userA);

    final unlockedByA = row.containsKey('unlocked_by_a')
        ? row['unlocked_by_a'] == true
        : (previous == null ? false : (isUserA ? previous.unlockedByMe : previous.unlockedByOther));
    final unlockedByB = row.containsKey('unlocked_by_b')
        ? row['unlocked_by_b'] == true
        : (previous == null ? false : (isUserA ? previous.unlockedByOther : previous.unlockedByMe));

    final rawUnlockedAt = row.containsKey('unlocked_at') ? row['unlocked_at'] : null;
    final unlockedAt = rawUnlockedAt == null
        ? previous?.unlockedAt
        : DateTime.tryParse(rawUnlockedAt.toString());

    setState(() {
      _match = MatchModel(
        id: row['id']?.toString() ?? previous?.id ?? widget.matchId,
        userA: userA,
        userB: userB,
        unlockedByMe: isUserA ? unlockedByA : unlockedByB,
        unlockedByOther: isUserA ? unlockedByB : unlockedByA,
        unlockedAt: unlockedAt,
        myCount: _myCount,
        theirCount: _theirCount,
      );
    });
  }

  Future<void> _handleUnlock() async {
    if (_isUnlocking) {
      return;
    }

    setState(() => _isUnlocking = true);
    try {
      await _repository.unlockMatch(widget.matchId);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kunne ikke låse profilen op lige nu.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUnlocking = false);
      }
    }
  }

  void _showSafetySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Blokér'),
                onTap: () => _confirmSafetyAction(
                  sheetContext,
                  context,
                  title: 'Blokér',
                  message: 'Er du sikker på, at du vil blokere denne profil?',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Rapportér'),
                onTap: () => _confirmSafetyAction(
                  sheetContext,
                  context,
                  title: 'Rapportér',
                  message: 'Er du sikker på, at du vil rapportere denne profil?',
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _confirmSafetyAction(
    BuildContext sheetContext,
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuller'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(sheetContext);
                debugPrint('TODO: $title action');
              },
              child: const Text('Bekræft'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final match = _match;
    final isReadyToUnlock = _unlockProgress >= 1;
    final unlockedByMe = match?.unlockedByMe ?? false;
    final unlockedByOther = match?.unlockedByOther ?? false;
    final isFullyUnlocked = match?.isFullyUnlocked ?? false;
    final isLocked = !isFullyUnlocked;

    final canUnlock = isReadyToUnlock && !unlockedByMe && isLocked && !_isUnlocking;
    final showButton = !isFullyUnlocked;
    final buttonLabel = unlockedByMe && !unlockedByOther ? 'Afventer match' : 'Lås op';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.premiumGradient,
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 88, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isLocked)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isReadyToUnlock
                                    ? AppColors.primary.withValues(alpha: 0.14)
                                    : Colors.black.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                isReadyToUnlock ? 'Klar' : 'Låst',
                                style: TextStyle(
                                  color: isReadyToUnlock
                                      ? AppColors.primary
                                      : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 340,
                              width: double.infinity,
                              child: Image.asset(
                                'assets/images/BDV4.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (isLocked)
                              Positioned.fill(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: _unlockProgress,
                          minHeight: 4,
                          backgroundColor: Colors.black.withValues(alpha: 0.08),
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (showButton)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: canUnlock ? _handleUnlock : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canUnlock
                                  ? AppColors.primary
                                  : Colors.grey.withValues(alpha: 0.6),
                              disabledBackgroundColor: Colors.grey.withValues(alpha: 0.6),
                              disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                              padding: const EdgeInsets.symmetric(vertical: 22),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: canUnlock ? 8 : 0,
                            ),
                            child: Text(
                              _isUnlocking ? 'Låser op...' : buttonLabel,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withValues(alpha: canUnlock ? 1 : 0.85),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Text(
                            '${widget.name}, ${widget.age}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textSoft,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () => _showSafetySheet(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
