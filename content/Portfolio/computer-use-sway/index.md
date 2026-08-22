---
title: "computer-use-sway"
date: 2026-07-31
draft: false
description: "A local MCP server for inspecting and operating a Sway desktop session"
tags: ["Python", "MCP", "Linux", "Wayland", "Sway"]
showHero: false
showTableOfContents: true
---

{{< lead >}}
A local stdio MCP server that lets trusted AI clients work with the active Sway/Wayland desktop through a small, explicit set of native capabilities.
{{< /lead >}}

## Controlled computer use

It can inspect outputs, seats, focused windows, and the window tree; capture screenshots; focus windows; and use pointer, keyboard, and clipboard actions through Sway-native tools. The server is deliberately local-only: it has no network listener and is registered only with clients the user chooses to trust.

{{< keywordList >}}
{{< keyword icon="eye" >}} Screen and window inspection {{< /keyword >}}
{{< keyword icon="pointer" >}} Pointer and keyboard control {{< /keyword >}}
{{< keyword icon="copy" >}} Clipboard integration {{< /keyword >}}
{{< keyword icon="shield" >}} Local stdio transport {{< /keyword >}}
{{< /keywordList >}}

## Operational detail

The server reconstructs the Wayland session variables a sanitized MCP host may omit, then runs against `swaymsg`, `grim`, `wtype`, and `wl-clipboard`. Its diagnostic command makes the required desktop contract inspectable before a client attempts control.

## Links

{{< button href="https://github.com/blackopsrepl/computer-use-sway" target="_blank" >}}
{{< icon "github" >}} Source
{{< /button >}}
