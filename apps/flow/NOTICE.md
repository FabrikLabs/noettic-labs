# Notice

Noettic Flow is a fork of [FluidVoice](https://github.com/altic-dev/FluidVoice)
by Altic (altic-dev), vendored from upstream commit
`0fccdeb014462e6f82889af38c7e9de92d87a130` (2026-10-24).

FluidVoice is licensed under the GNU General Public License v3.0. Everything in
this `apps/flow` directory is therefore also distributed under GPLv3 (see
`LICENSE` in this directory). The root of the repository remains MIT licensed;
the two licenses apply to disjoint sets of files.

Changes made in this fork:

- Rebranded as Noettic Flow (product name, bundle identifier, storage folders,
  keychain service, in-app copy). Upstream analytics keys and feedback
  endpoints were removed or repointed.
- Dictionary import accepts Wispr Flow CSV exports in addition to the native
  JSON format.
- Wispr-style navigation labels (Dictionary, Styles, Notetaker) and a new
  Scratchpad page for dictating into a persistent in-app note.
- GitHub Actions build that produces an ad-hoc signed `.app`, `.zip` and
  `.dmg` for Apple Silicon Macs.

Fluid Intelligence, Altic's private on-device enhancement runtime, is not part
of the open-source upstream and is not included here.
