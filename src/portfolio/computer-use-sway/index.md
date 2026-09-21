---
title: "computer-use-sway"
date: 2026-07-31
draft: false
description: "A local MCP server for inspecting and operating a Sway desktop session"
tags: ["Python", "MCP", "Linux", "Wayland", "Sway"]
showHero: false
showTableOfContents: true
showBreadcrumbs: true
showReadingTime: true
showWordCount: true
---

<div class="lead"><p>Give a trusted AI client useful control of a real Sway desktop—without adding a network service or pretending the security boundary does not exist.</p></div>

computer-use-sway is a local MCP stdio server for inspecting and operating the current Wayland session through Sway-native tools. It turns the desktop into a small explicit capability surface instead of an opaque remote-control channel.

<div class="keyword-list"><span class="keyword-pill"><img class="inline-icon" src="/icons/eye.svg" alt="" width="16" height="16">Screen and window inspection</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Pointer control</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Text and key chords</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Clipboard access</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/shield.svg" alt="" width="16" height="16">Local stdio transport</span></div>

## What the client can see and do

<div class="timeline"><article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Observe the session</h3><span class="timeline-badge">Read</span><p class="timeline-subheader">Outputs, seats, focused windows, and required binaries</p></header>
    <div class="timeline-item-body"><p>The server returns the state needed to reason about the current desktop before acting. A simplified Sway tree provides stable window identity without exposing the full compositor structure as raw noise.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Capture the screen</h3><span class="timeline-badge">Image</span><p class="timeline-subheader">Screenshots as MCP image content or data URLs</p></header>
    <div class="timeline-item-body"><p>The client can receive a current visual surface through <code>grim</code>, then combine it with structured focus and window information.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Operate deliberately</h3><span class="timeline-badge">Write</span><p class="timeline-subheader">Focus, point, click, drag, scroll, type, and send chords</p></header>
    <div class="timeline-item-body"><p>Window targeting works by container ID, app ID, class, or title. Pointer and keyboard actions use native Wayland tools rather than an X11 compatibility path.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Exchange text</h3><span class="timeline-badge">Clipboard</span><p class="timeline-subheader">Read and write the text clipboard</p></header>
    <div class="timeline-item-body"><p>Clipboard capabilities use <code>wl-clipboard</code> and remain separate from keyboard entry, so the client can choose the least disruptive mechanism for a task.</p></div>
  </div>
</article></div>

## A narrow local bridge

<aside class="alert"><p>This server gives an MCP client practical control of the active desktop. It should only be registered with local clients the user trusts.</p></aside>

There is no HTTP listener and no remote account. The MCP host launches the server over stdio. When that host starts with a sanitized environment, the server reconstructs `XDG_RUNTIME_DIR`, `SWAYSOCK`, and `WAYLAND_DISPLAY` from the active local session, then diagnoses the required tools before accepting desktop work.

<pre class="not-prose mermaid">sequenceDiagram
    participant Client as Trusted MCP client
    participant Server as computer-use-sway
    participant Sway as Sway / Wayland tools
    Client-&gt;&gt;Server: Inspect session
    Server-&gt;&gt;Sway: swaymsg / grim
    Sway--&gt;&gt;Server: Tree, focus, screenshot
    Server--&gt;&gt;Client: Structured state + image
    Client-&gt;&gt;Server: Explicit input action
    Server-&gt;&gt;Sway: wtype / pointer / clipboard</pre>

## Project identity

<div class="gallery"><img src="mascot.png" class="grid-w50 md:grid-w50" loading="lazy" decoding="async" alt="computer-use-sway mascot operating a Sway desktop" /></div>

## Repository

<div class="github-card"><a href="https://github.com/blackopsrepl/computer-use-sway">blackopsrepl/computer-use-sway</a></div>

<a class="button" href="https://github.com/blackopsrepl/computer-use-sway" target="_blank"><img class="inline-icon" src="/icons/github.svg" alt="" width="16" height="16" /> Source and setup</a>
