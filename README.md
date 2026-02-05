# blind_date

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Blind Date – Beta v0.1

## Status
Beta-MVP: Auth, profiles, mutual matchmaking queue, matches, realtime chat.

## Flows der virker
- Magic link login + logout
- Enroll -> gem profil i Supabase (profiles)
- Open Chats:
  - viser match navn/alder
  - sidste besked preview
  - progress + “din tur”
- Secret Chat:
  - realtime messages
  - progress stiger ved beskeder
  - header viser match navn/alder (RLS for matched profiles)
- Find blind date:
  - mutual intent via matchmaking_queue
  - RPC try_matchmake() opretter matches når begge søger

## Backend (Supabase)
Tabeller:
- profiles
- matches
- messages
- matchmaking_queue

RLS noter:
- profiles: matched profiles policy + discovery policy (beta)
- matches: insert policy (user_a/user_b inkluderer auth.uid)
- messages: select+insert policies
- matchmaking_queue: users can upsert their own row

## Feature flags (AppConfig)
- useRemoteProfile = true/false
- useRemoteChat = true/false
- useRemoteMatchmaking = true/false

## Kendte TODOs
- Ryd op i discovery policy (profiles) -> evt RPC-only matchmaking senere
- “Søger…” UX polish (loading state)
- Block/report flow
- Billeder + unlock persistens (unlocked state)

## Dev commands
- flutter run -d chrome --web-port 3000
