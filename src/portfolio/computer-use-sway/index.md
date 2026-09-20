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

{{< lead >}}
Give a trusted AI client useful control of a real Sway desktop—without adding a network service or pretending the security boundary does not exist.
{{< /lead >}}

computer-use-sway is a local MCP stdio server for inspecting and operating the current Wayland session through Sway-native tools. It turns the desktop into a small explicit capability surface instead of an opaque remote-control channel.

{{< keywordList >}}
{{< keyword icon="eye" >}} Screen and window inspection {{< /keyword >}}
{{< keyword icon="pointer" >}} Pointer control {{< /keyword >}}
{{< keyword icon="keyboard" >}} Text and key chords {{< /keyword >}}
{{< keyword icon="copy" >}} Clipboard access {{< /keyword >}}
{{< keyword icon="shield" >}} Local stdio transport {{< /keyword >}}
{{< /keywordList >}}

## What the client can see and do

{{< timeline >}}

{{< timelineItem icon="display" header="Observe the session" badge="Read" subheader="Outputs, seats, focused windows, and required binaries" >}}
The server returns the state needed to reason about the current desktop before acting. A simplified Sway tree provides stable window identity without exposing the full compositor structure as raw noise.
{{< /timelineItem >}}

{{< timelineItem icon="camera" header="Capture the screen" badge="Image" subheader="Screenshots as MCP image content or data URLs" >}}
The client can receive a current visual surface through `grim`, then combine it with structured focus and window information.
{{< /timelineItem >}}

{{< timelineItem icon="pointer" header="Operate deliberately" badge="Write" subheader="Focus, point, click, drag, scroll, type, and send chords" >}}
Window targeting works by container ID, app ID, class, or title. Pointer and keyboard actions use native Wayland tools rather than an X11 compatibility path.
{{< /timelineItem >}}

{{< timelineItem icon="copy" header="Exchange text" badge="Clipboard" subheader="Read and write the text clipboard" >}}
Clipboard capabilities use `wl-clipboard` and remain separate from keyboard entry, so the client can choose the least disruptive mechanism for a task.
{{< /timelineItem >}}

{{< /timeline >}}

## A narrow local bridge

{{< alert icon="triangle-exclamation" >}}
This server gives an MCP client practical control of the active desktop. It should only be registered with local clients the user trusts.
{{< /alert >}}

There is no HTTP listener and no remote account. The MCP host launches the server over stdio. When that host starts with a sanitized environment, the server reconstructs `XDG_RUNTIME_DIR`, `SWAYSOCK`, and `WAYLAND_DISPLAY` from the active local session, then diagnoses the required tools before accepting desktop work.

{{< mermaid >}}
sequenceDiagram
    participant Client as Trusted MCP client
    participant Server as computer-use-sway
    participant Sway as Sway / Wayland tools
    Client->>Server: Inspect session
    Server->>Sway: swaymsg / grim
    Sway-->>Server: Tree, focus, screenshot
    Server-->>Client: Structured state + image
    Client->>Server: Explicit input action
    Server->>Sway: wtype / pointer / clipboard
{{< /mermaid >}}

## Project identity

{{< gallery >}}
  <img src="mascot.png" class="grid-w50 md:grid-w50" loading="lazy" decoding="async" alt="computer-use-sway mascot operating a Sway desktop" />
{{< /gallery >}}

## Repository

{{< github repo="blackopsrepl/computer-use-sway" showThumbnail=false >}}

{{< button href="https://github.com/blackopsrepl/computer-use-sway" target="_blank" >}}
{{< icon "github" >}} Source and setup
{{< /button >}}
