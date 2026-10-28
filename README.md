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
├── README.md          # This file
├── LICENSE            # MIT License
├── .gitignore         # Git ignore rules
├── index.html         # Noettic Labs site
└── prompts/           # Building from Zero prompt library (prompts.buildingfromzero.co)
    ├── PROMPT-LIBRARY.md   # The content: edit this, the page renders it
    └── index.html          # Static renderer, deployed as its own Vercel project
```

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
