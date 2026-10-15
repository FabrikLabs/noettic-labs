# Noettic video pilot — "Your AI writes like everyone else's"

A 73-second pilot for a Noettic teaching channel, in the style of AI Labs:
faceless voiceover, clean recreated UI, one accent color, motion timed to the words.
Built with [HyperFrames](https://hyperframes.heygen.com) (HTML + GSAP → MP4).

Output: `renders/noettic-pilot.mp4`

## How an episode gets made

1. **Write `SCRIPT.md`.** One `## <scene-id>` section per scene. Each sentence is a "beat"
   — a moment the visuals can react to.
2. **Run `python3 tools/build-vo.py`.** It speaks every sentence with the local Kokoro voice,
   stitches them into `assets/audio/narration.wav`, and rewrites the timing in `index.html`
   (each scene's start, length, and beat offsets). Change a line of script, re-run,
   and the whole video re-times itself.
3. **Build or reuse scenes** in `compositions/`. Each scene reads its beat offsets
   (`beats`) and length (`dur`) and fires its animations on those beats.
4. **Check and render:**
   ```bash
   npx hyperframes lint
   npx hyperframes check
   npx hyperframes snapshot --at 2,10,20      # contact sheet of chosen moments
   npx hyperframes preview --background       # Studio: click anything to edit
   npx hyperframes render --quality high --output renders/noettic-pilot.mp4
   ```

## The kit

| Piece | File | What it is |
|---|---|---|
| Tokens + blocks | `assets/noettic-kit.css` | Site colors and type; card, window chrome, terminal, typing, skeleton bars, pills, nodes + wires, file card, step header |
| Ground | `compositions/kit-ground.html` | Navy, dot grid, slow blue glow, vignette |
| Corner mark | `compositions/kit-mark.html` | The "N" channel bug |
| Scenes | `compositions/s01…s08` | Hook (look-alike posts) · title (node → file) · context window · step 01–03 · reviewer pipeline · CTA + end card |

Scene patterns worth copying into future episodes: three-card comparison with highlight
sweeps (s01), node + wire with a travelling pulse (s02), context window with a token meter
(s03), files flowing into a node with a count-up (s04), terminal typing + tool lines next to
a document (s05/s06), a draft moving through a review pipeline (s07).

## Placeholders to replace before publishing

- **Voice:** Kokoro `am_michael` is a stand-in. Swap in a cloned voice of Chris
  (ElevenLabs, HeyGen, or VoiceStudio), keeping one file per sentence so timing still works.
- **Script claims:** written in the Noettic voice; Chris should confirm every line.
- **Mock content:** post copy, file names and rules in the UI mocks are illustrative.
- **Music:** none. Add a quiet bed under the voice before publishing.
- **CTA:** "Link in the description" assumes a real starter skill to link to.

## Notes

- GSAP and fonts are bundled in `assets/` so renders don't depend on the network.
- Claude is shown as a generic "›_" node, not with Anthropic's logo or mascot.
