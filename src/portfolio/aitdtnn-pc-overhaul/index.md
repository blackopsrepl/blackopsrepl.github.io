---
title: "AITD:TNN PC Overhaul"
date: 2026-08-20
draft: false
description: "A preservation and compatibility overhaul for Alone in the Dark: The New Nightmare on modern Windows"
tags: ["C++", "Game Preservation", "Windows", "OpenGL", "Reverse Engineering"]
---

<div class="lead"><p>Preserve the original PC game. Restore the parts modern hardware and an incomplete port left behind.</p></div>

AITD:TNN PC Overhaul is an independent compatibility and preservation layer for the Windows release of *Alone in the Dark: The New Nightmare*. It keeps the original story, game data, sound effects, movies, and executable intact while restoring selected Dreamcast-era features and correcting presentation and input on current systems.

<div class="keyword-list"><span class="keyword-pill"><img class="inline-icon" src="/icons/music.svg" alt="" width="16" height="16">Interactive Dreamcast audio</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Proportional 4:3 rendering</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">XInput and original rumble</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Restored movie flow</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/shield.svg" alt="" width="16" height="16">Fail-closed compatibility</span></div>

## In the game

These captures come from the supported PC build with the overhaul active: the title sequence, first playable scene, and inventory all pass through the same proportional OpenGL presentation path.

<div class="gallery"><img src="title-screen.jpg" loading="lazy" decoding="async" alt="Alone in the Dark title screen rendered through the overhaul" />
  <img src="first-scene.jpg" loading="lazy" decoding="async" alt="First playable scene with proportional 4:3 presentation and CRT treatment" />
  <img src="inventory-menu.jpg" loading="lazy" decoding="async" alt="Original inventory interface rendered through the compatibility layer" /></div>

## What the overhaul restores

<div class="timeline"><article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/music.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Live music and ambience</h3><span class="timeline-badge">Dreamcast</span><p class="timeline-subheader">Manatee/AICA synthesis driven by PC gameplay events</p></header>
    <div class="timeline-item-body"><p>The Dreamcast music system follows the PC engine’s live cues. Native PC effects and FMV audio remain on their original paths, so the result is an integration rather than a replacement soundtrack.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Correct presentation</h3><span class="timeline-badge">OpenGL 3.3</span><p class="timeline-subheader">A stable 4:3 signal on modern displays</p></header>
    <div class="timeline-item-body"><p>Borderless fullscreen, pillarboxing, optional MSAA and anisotropic filtering, VSync, and edge-sampling fixes remove modern-driver friction without inventing widescreen geometry.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Controller support and rumble</h3><span class="timeline-badge">XInput</span><p class="timeline-subheader">Legacy input translated for current controllers</p></header>
    <div class="timeline-item-body"><p>The packaged controller layer maps Xbox-compatible devices into the interfaces the game expects, while the game’s retained Dreamcast vibration profiles drive the modern controller motors.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Character-selection movies</h3><span class="timeline-badge">Restored</span><p class="timeline-subheader">The verified continuation path runs in the intended order</p></header>
    <div class="timeline-item-body"><p>Character confirmation, portrait and title voice, native movie playback, and route setup are reconnected. A runtime ledger records movie requests, opens, frames, and closes for diagnosis.</p></div>
  </div>
</article></div>

<aside class="alert"><p><strong>Asset boundary:</strong> the user provides their own legitimately acquired PC installation and Dreamcast disc image. The repository does not redistribute either game’s copyrighted assets; the installer extracts the required audio data locally.</p></aside>

## Preservation without rewriting the work

The restraint is deliberate. There is no executable replacement, AI texture pass, widescreen projection, replacement movie system, or stylized color grade. The optional CRT treatment is intentionally modest: scanlines, a subtle aperture grille, and mild halation for the original 640×480 signal.

Address-sensitive modules support one exact executable build and refuse to load elsewhere. Installation and uninstall are ownership-aware: existing files are backed up, modified files are preserved, and unknown additions are never silently deleted. That makes reversibility part of the product rather than an afterthought.

## Engineering surface

The maintained system spans 32-bit C/C++ runtime modules, OpenGL shaders, Dreamcast audio-bank extraction, XInput translation, PowerShell release tooling, and an Inno Setup installer. Release validation covers the integrated payload and a destructive installer lifecycle matrix in a disposable test directory.

## Repository

<div class="github-card"><a href="https://github.com/blackopsrepl/aitdtnn-pc-overhaul">blackopsrepl/aitdtnn-pc-overhaul</a></div>

<a class="button" href="https://github.com/blackopsrepl/aitdtnn-pc-overhaul/releases" target="_blank"><img class="inline-icon" src="/icons/download.svg" alt="" width="16" height="16" /> Releases</a>
