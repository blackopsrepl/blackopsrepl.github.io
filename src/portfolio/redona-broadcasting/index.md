---
title: "Redona Broadcasting"
date: 2026-10-21
draft: false
description: "A neighbourhood video studio in Bergamo: shops send phone clips on WhatsApp, an agent plans the edit, and every video is verified before a human sees it"
tags: ["Python", "AI Agents", "Video", "Automation", "Local Business"]
---

<div class="lead"><p>A video studio for the shops in my neighbourhood. The baker, the barber and the bar send me what they shot on their phone, over WhatsApp. They get back edited, captioned vertical videos for Instagram, TikTok, YouTube and Facebook, at a flat €299 a month.</p></div>

Redona is my neighbourhood in Bergamo. Its shops don't need an agency or a strategy deck. They need someone to turn five minutes of shaky phone footage into something worth posting. Redona Broadcasting does that with an AI agent doing the editorial judgement and deterministic code doing everything that has to be exactly right.

The public face is an [Italian one-page site](/redona/) with a mascot, the Baffo: me, as a 1990s Italian TV-shopping host. Underneath it is a production studio rebuilt from an OpenShorts fork.

<div class="keyword-list"><span class="keyword-pill"><img class="inline-icon" src="/icons/whatsapp.svg" alt="" width="16" height="16">WhatsApp intake</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/wand-magic-sparkles.svg" alt="" width="16" height="16">Agent-planned edits</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/check.svg" alt="" width="16" height="16">Verified before review</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/shield.svg" alt="" width="16" height="16">Real footage only</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/location-dot.svg" alt="" width="16" height="16">Redona, Bergamo</span></div>

## The page

<div class="gallery"><img src="redona-hero.png" loading="lazy" decoding="async" alt="The Redona Broadcasting hero: 'Il tuo negozio, in onda dappertutto' next to a yellow TV showing the Baffo mascot" />
<img src="redona-price.png" loading="lazy" decoding="async" alt="The pricing section: one plan at 299 euro a month, everything included" />
<img src="redona-under-the-hood.png" loading="lazy" decoding="async" alt="The under-the-hood section: a terminal running the quality checks every video passes" /></div>

Italian only, very local, deliberately loud: Bergamo's red and yellow, a TV-shopping mascot, one price, no tiers. The technology appears once, in a terminal window, as the list of checks every video passes. The page sells the outcome, not the AI.

## How a video gets made

<div class="timeline"><article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/whatsapp.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Intake</h3><span class="timeline-badge">Files</span><p class="timeline-subheader">Originals copied, hashed and probed, never modified</p></header>
    <div class="timeline-item-body"><p>Each job keeps the client's files exactly as received, with SHA-256 hashes and probe data including phone rotation. Transcription is Whisper only, pinned, with word-level timestamps.</p></div>
  </div>
</article>

<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/wand-magic-sparkles.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>The agent plans</h3><span class="timeline-badge">Judgement</span><p class="timeline-subheader">A Hermes agent writes a versioned JSON edit plan</p></header>
    <div class="timeline-item-body"><p>Which moments, which cut, which captions. The agent follows a versioned skill and works in two modes: merge several clips into one edit, or split one long video into vertical clips. No model is called from inside the studio code; the agent's only output is the plan.</p></div>
  </div>
</article>

<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/scale-balanced.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Code validates</h3><span class="timeline-badge">Rules</span><p class="timeline-subheader">The plan is rejected unless it obeys the editing rules</p></header>
    <div class="timeline-item-body"><p>Cuts only in word gaps, with room after the last word. Picture and sound from the same take for speech. Captions only over voiced segments. The client's logo unaltered, checked by hash. These are enforced by a validator, not by prompt wording.</p></div>
  </div>
</article>

<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Render</h3><span class="timeline-badge">Deterministic</span><p class="timeline-subheader">Headless FilmCraft, with an ffmpeg fallback behind the same plan</p></header>
    <div class="timeline-item-body"><p>The same plan on the pinned toolchain gives the same output: three independent renders of the first client job produced byte-identical masters. One delivery profile for every platform.</p></div>
  </div>
</article>

<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/check.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Verify</h3><span class="timeline-badge">Gates</span><p class="timeline-subheader">Checked before a human ever sees it</p></header>
    <div class="timeline-item-body"><p>Full decode, audio/video alignment, re-transcription against the plan so no sentence is clipped, OCR of the burned captions on real frames, and playback on real GPU hardware in a private headless compositor. A version that passes every gate is approved automatically into the review ledger.</p></div>
  </div>
</article></div>

## Rules the studio keeps

- **Real footage only.** No generated video, voices, actors or dubbing. The shop owner is in the video, in the shop.
- **The client's brand is never altered.** Logos are used as supplied.
- **The agent decides, code enforces.** Everything a model could get subtly wrong is a validator rule or a verification gate.

## Status

The first client, a bakery, is live, with a paid month and delivered reels. The manual workflow runs end to end, from files to verified, auto-approved versions in the ledger. The editing skill has also passed on a second model: given only the skill and the original clips, it produced a valid plan that passed every gate.

<a class="button" href="/redona/"><img class="inline-icon" src="/icons/globe.svg" alt="" width="16" height="16" /> Redona Broadcasting (Italian)</a>
