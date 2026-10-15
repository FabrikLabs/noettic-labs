#!/usr/bin/env python3
"""Build the narration track and sync every scene to it.

Reads SCRIPT.md (one `## <scene-id>` section per scene), speaks each sentence
separately with the local Kokoro voice, and stitches the clips into one
narration file. Because every sentence is its own clip, we know exactly when
each one starts — no speech-to-text step needed.

Outputs:
  assets/audio/narration.wav   the full voiceover
  timings.json                 scene starts/durations + sentence ("beat") offsets
  index.html                   host data-start / data-duration / beats rewritten

Usage:  python3 tools/build-vo.py [--voice am_michael] [--speed 1.0]
"""
import argparse
import json
import re
from pathlib import Path

import numpy as np
import soundfile as sf
from kokoro_onnx import Kokoro

ROOT = Path(__file__).resolve().parent.parent
CACHE = Path.home() / ".cache/hyperframes/tts"
SR = 24000

GAP_BEAT = 0.22    # silence between sentences inside a scene
LEAD_IN = 0.35     # silence before a scene's first word
TAIL = 0.55        # silence after a scene's last word (lets visuals settle)


def parse_script(text):
    scenes = []
    for m in re.finditer(r"^## (\S+)\n(.+?)(?=\n## |\Z)", text, re.S | re.M):
        body = " ".join(m.group(2).split())
        # A beat is a sentence; a colon also starts a new beat ("a reviewer.")
        beats = [b.strip() for b in re.split(r"(?<=[.!?:])\s+", body) if b.strip()]
        scenes.append({"id": m.group(1), "beats": beats})
    return scenes


def silence(seconds):
    return np.zeros(int(seconds * SR), dtype=np.float32)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--voice", default="am_michael")
    ap.add_argument("--speed", type=float, default=1.0)
    args = ap.parse_args()

    scenes = parse_script((ROOT / "SCRIPT.md").read_text())
    kokoro = Kokoro(str(CACHE / "models/kokoro-v1.0.onnx"), str(CACHE / "voices/voices-v1.0.bin"))

    track, t = [], 0.0
    for scene in scenes:
        scene["start"] = round(t, 3)
        local = LEAD_IN
        track.append(silence(LEAD_IN))
        offsets = []
        for i, beat in enumerate(scene["beats"]):
            samples, sr = kokoro.create(beat, voice=args.voice, speed=args.speed, lang="en-us")
            assert sr == SR
            offsets.append(round(local, 3))
            track.append(samples.astype(np.float32))
            local += len(samples) / SR
            if i < len(scene["beats"]) - 1:
                track.append(silence(GAP_BEAT))
                local += GAP_BEAT
        track.append(silence(TAIL))
        local += TAIL
        scene["offsets"] = offsets
        scene["duration"] = round(local, 3)
        t += local
        print(f"{scene['id']:<10} start {scene['start']:6.2f}s  dur {scene['duration']:5.2f}s  beats {offsets}")

    audio = np.concatenate(track)
    sf.write(ROOT / "assets/audio/narration.wav", audio, SR)
    total = round(len(audio) / SR, 3)
    (ROOT / "timings.json").write_text(json.dumps({"total": total, "scenes": scenes}, indent=2))

    # Rewrite each scene host in index.html: <div id="scene-<id>" ... data-start data-duration beats>
    html = (ROOT / "index.html").read_text()
    for s in scenes:
        pat = re.compile(r'(<div\s+id="scene-%s"[^>]*?)>' % re.escape(s["id"]), re.S)
        m = pat.search(html)
        if not m:
            print(f"  ! no host for scene-{s['id']} in index.html")
            continue
        tag = m.group(1)
        tag = re.sub(r'data-start="[^"]*"', f'data-start="{s["start"]}"', tag)
        tag = re.sub(r'data-duration="[^"]*"', f'data-duration="{s["duration"]}"', tag)
        tag = re.sub(r"data-variable-values='[^']*'",
                     "data-variable-values='%s'" % json.dumps({"beats": json.dumps(s["offsets"]), "dur": s["duration"]}), tag)
        html = html[:m.start()] + tag + ">" + html[m.end():]
    html = re.sub(r'(data-composition-id="main"[^>]*?data-duration=")[^"]*(")', rf"\g<1>{total}\g<2>", html, flags=re.S)
    # Layers that run the whole video (background, watermark, narration) carry data-span="full"
    html = re.sub(r'(data-span="full"[^>]*?data-duration=")[^"]*(")', rf"\g<1>{total}\g<2>", html, flags=re.S)
    html = re.sub(r"""(data-span="full"[^>]*?data-variable-values=')[^']*(')""", rf'\g<1>{{"dur": {total}}}\g<2>', html, flags=re.S)
    (ROOT / "index.html").write_text(html)
    print(f"total {total}s → assets/audio/narration.wav, timings.json, index.html")


if __name__ == "__main__":
    main()
