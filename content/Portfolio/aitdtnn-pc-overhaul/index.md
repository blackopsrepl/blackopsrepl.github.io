---
title: "AITD:TNN PC Overhaul"
date: 2026-08-20
draft: false
description: "A preservation and compatibility overhaul for Alone in the Dark: The New Nightmare on modern Windows"
tags: ["C++", "Game Preservation", "Windows", "OpenGL", "Reverse Engineering"]
showHero: false
showTableOfContents: true
showBreadcrumbs: true
showReadingTime: true
showWordCount: true
---

{{< lead >}}
Preserve the original PC game. Restore the parts modern hardware and an incomplete port left behind.
{{< /lead >}}

AITD:TNN PC Overhaul is an independent compatibility and preservation layer for the Windows release of *Alone in the Dark: The New Nightmare*. It keeps the original story, game data, sound effects, movies, and executable intact while restoring selected Dreamcast-era features and correcting presentation and input on current systems.

{{< keywordList >}}
{{< keyword icon="music" >}} Interactive Dreamcast audio {{< /keyword >}}
{{< keyword icon="display" >}} Proportional 4:3 rendering {{< /keyword >}}
{{< keyword icon="gamepad" >}} XInput and original rumble {{< /keyword >}}
{{< keyword icon="film" >}} Restored movie flow {{< /keyword >}}
{{< keyword icon="shield" >}} Fail-closed compatibility {{< /keyword >}}
{{< /keywordList >}}

## In the game

These captures come from the supported PC build with the overhaul active: the title sequence, first playable scene, and inventory all pass through the same proportional OpenGL presentation path.

{{< gallery >}}
  <img src="title-screen.jpg" class="grid-w50 md:grid-w50" loading="lazy" decoding="async" alt="Alone in the Dark title screen rendered through the overhaul" />
  <img src="first-scene.jpg" class="grid-w50 md:grid-w50" loading="lazy" decoding="async" alt="First playable scene with proportional 4:3 presentation and CRT treatment" />
  <img src="inventory-menu.jpg" class="grid-w50 md:grid-w50" loading="lazy" decoding="async" alt="Original inventory interface rendered through the compatibility layer" />
{{< /gallery >}}

## What the overhaul restores

{{< timeline >}}

{{< timelineItem icon="music" header="Live music and ambience" badge="Dreamcast" subheader="Manatee/AICA synthesis driven by PC gameplay events" >}}
The Dreamcast music system follows the PC engine’s live cues. Native PC effects and FMV audio remain on their original paths, so the result is an integration rather than a replacement soundtrack.
{{< /timelineItem >}}

{{< timelineItem icon="display" header="Correct presentation" badge="OpenGL 3.3" subheader="A stable 4:3 signal on modern displays" >}}
Borderless fullscreen, pillarboxing, optional MSAA and anisotropic filtering, VSync, and edge-sampling fixes remove modern-driver friction without inventing widescreen geometry.
{{< /timelineItem >}}

{{< timelineItem icon="gamepad" header="Controller support and rumble" badge="XInput" subheader="Legacy input translated for current controllers" >}}
The packaged controller layer maps Xbox-compatible devices into the interfaces the game expects, while the game’s retained Dreamcast vibration profiles drive the modern controller motors.
{{< /timelineItem >}}

{{< timelineItem icon="film" header="Character-selection movies" badge="Restored" subheader="The verified continuation path runs in the intended order" >}}
Character confirmation, portrait and title voice, native movie playback, and route setup are reconnected. A runtime ledger records movie requests, opens, frames, and closes for diagnosis.
{{< /timelineItem >}}

{{< /timeline >}}

{{< alert icon="shield" >}}
**Asset boundary:** the user provides their own legitimately acquired PC installation and Dreamcast disc image. The repository does not redistribute either game’s copyrighted assets; the installer extracts the required audio data locally.
{{< /alert >}}

## Preservation without rewriting the work

The restraint is deliberate. There is no executable replacement, AI texture pass, widescreen projection, replacement movie system, or stylized color grade. The optional CRT treatment is intentionally modest: scanlines, a subtle aperture grille, and mild halation for the original 640×480 signal.

Address-sensitive modules support one exact executable build and refuse to load elsewhere. Installation and uninstall are ownership-aware: existing files are backed up, modified files are preserved, and unknown additions are never silently deleted. That makes reversibility part of the product rather than an afterthought.

## Engineering surface

The maintained system spans 32-bit C/C++ runtime modules, OpenGL shaders, Dreamcast audio-bank extraction, XInput translation, PowerShell release tooling, and an Inno Setup installer. Release validation covers the integrated payload and a destructive installer lifecycle matrix in a disposable test directory.

## Repository

{{< github repo="blackopsrepl/aitdtnn-pc-overhaul" showThumbnail=false >}}

{{< button href="https://github.com/blackopsrepl/aitdtnn-pc-overhaul/releases" target="_blank" >}}
{{< icon "download" >}} Releases
{{< /button >}}
