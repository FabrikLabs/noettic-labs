# Noettic Labs

> Building intelligent tools that think with you.

## Overview

This is the core repository for Noettic Labs. Product direction and tech stack are being finalized — see the [engineering roadmap](#) for current priorities.

## Getting Started

### Prerequisites

- Node.js 20+
- Git

### Clone & Run Locally

```bash
git clone https://github.com/askchrislive/noettic-labs.git
cd noettic-labs
# Install dependencies (package manager TBD with tech stack)
# npm install
# npm run dev
```

> **Note:** Full setup instructions will be added once the tech stack is selected (tracked in NOE-5).

## Repository Structure

```
noettic-labs/
├── index.html          # Noettic Labs website (MIT)
├── apps/
│   └── flow/           # Noettic Flow: macOS dictation app, a FluidVoice fork (GPLv3)
├── .github/workflows/  # CI, including the Noettic Flow macOS build
├── README.md           # This file
└── LICENSE             # MIT License for everything outside apps/flow
```

### Noettic Flow

`apps/flow` is a Wispr Flow-style dictation app for Apple Silicon Macs: global
hotkey, on-device speech models, Dictionary (with Wispr Flow CSV import),
Styles, Scratchpad and Notetaker. It builds on GitHub Actions; download the
`.dmg` from the latest *Noettic Flow macOS build* run or from a tagged release.
See [apps/flow/README.md](apps/flow/README.md) for install, permissions and
build instructions.

## Contributing

1. Fork the repo or create a branch from `main`
2. Make your changes
3. Open a pull request — all PRs require at least one review before merging
4. Ensure CI passes before requesting review

## Branch Strategy

- `main` — production-ready, protected (requires PR + review)
- Feature branches: `feat/your-feature-name`
- Bug fixes: `fix/your-fix-name`

## License

MIT — see [LICENSE](./LICENSE).
