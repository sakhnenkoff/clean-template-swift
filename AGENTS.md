# AGENTS.md

This file provides guidance to AI coding agents (Codex CLI, etc.) when working with this repository.

---

## Primary Documentation

**Read the main documentation file first:**

→ **[CLAUDE.md](./CLAUDE.md)**

This file contains all project architecture, coding standards, and action workflows.

---

## Quick Summary

- **Architecture**: VIPER + RIBs pattern (View, Presenter, Router, Interactor per screen)
- **Tech Stack**: SwiftUI, Swift 5.9+, Firebase, RevenueCat, Mixpanel
- **Build Configs**: Mock (no Firebase), Dev, Prod
- **Packages**: SwiftfulThinking ecosystem + local SPM packages

---

## Documentation Structure

All detailed documentation is in `.claude/docs/`:

| File | Purpose |
|------|---------|
| `project-structure.md` | Architecture overview, folder structure |
| `viper-architecture.md` | VIPER layer rules, UI guidelines |
| `commit-guidelines.md` | Commit message format |
| `package-dependencies.md` | SwiftfulThinking package integration |
| `package-quick-reference.md` | Quick snippets and common patterns |
| `enhanced-features.md` | SPM packages, environment config, utilities |
| `action-create-screen.md` | How to create new VIPER screens |
| `action-create-component.md` | How to create reusable components |
| `action-create-manager.md` | How to create new managers |
| `action-create-model.md` | How to create data models |

---

## Critical Rules

1. **VIPER Data Flow**: View → Presenter → Interactor → Manager (never skip layers)
2. **Components are dumb UI**: No @State for data, all data injected via init
3. **Use templates**: Xcode templates exist for screens, managers, models
4. **File creation**: Use Write/Edit tools - Xcode 15+ auto-syncs files
5. **Analytics**: All Presenter methods must track events

---

## File Locations

- **Screens**: `/CleanTemplate/Core/[ScreenName]/`
- **Managers**: `/CleanTemplate/Managers/[ManagerName]/`
- **Components**: `/CleanTemplate/Components/Views/`
- **Extensions**: `/CleanTemplate/Extensions/`
- **SPM Packages**: `/Packages/` (Domain, Data, Networking, LocalPersistance, DesignSystem)

---

For complete details, read **[CLAUDE.md](./CLAUDE.md)** and the files in `.claude/docs/`.
