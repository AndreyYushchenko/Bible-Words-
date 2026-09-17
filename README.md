# Bible Words

A Ukrainian-language biblical word puzzle game built with Flutter. Players spell words from a
letter wheel to fill in a crossword, earn coins, unlock levels and achievements.

## Features

- Splash, Home, Level Select, Gameplay, Level Complete, Hints, Achievements, Statistics,
  Profile, Daily Challenge and Settings screens
- A fully playable "Імена людей" category (3 hand-authored levels) with a working
  tap-to-spell letter wheel and crossword-fill mechanic
- Local persistence (coins, streak, stars, settings) via `shared_preferences`
- Navigation via `go_router`, state via `provider`

## Getting started

```sh
flutter pub get
flutter run
```

## Project structure

```
lib/
  models/      data classes (Category, Level, Achievement, PlayerProfileData)
  data/        static content (categories, levels, achievements)
  state/       PlayerProvider — app-wide game/player state
  theme/       colors, gradients, text styles
  widgets/     shared UI (buttons, letter wheel, crossword grid, nav bar, cards)
  screens/     one file per screen, wired up via go_router in app.dart
```
