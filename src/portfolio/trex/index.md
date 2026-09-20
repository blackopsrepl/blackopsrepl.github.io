---
title: "trex"
date: 2025-12-01
draft: false
description: "A fast, minimal tmux session manager with fuzzy finding and an interactive TUI. Written in Rust."
tags: ["Rust", "CLI", "TUI", "Developer Tools", "tmux"]
showHero: true
heroStyle: "big"
showTableOfContents: true
showBreadcrumbs: true
showReadingTime: true
showWordCount: true
---

{{< lead >}}
{{< typeit
  tag=h3
  speed=40
  breakLines=false
  loop=false
>}}
A fast, minimal tmux session manager with fuzzy finding and vim-like keybindings.
{{< /typeit >}}
{{< /lead >}}

{{< keywordList >}}
{{< keyword icon="code" >}} Interactive TUI {{< /keyword >}}
{{< keyword icon="search" >}} Fuzzy Finding {{< /keyword >}}
{{< keyword icon="edit" >}} Vim Keybindings {{< /keyword >}}
{{< keyword icon="bolt" >}} Zero Config {{< /keyword >}}
{{< keyword icon="github" >}} Open Source {{< /keyword >}}
{{< /keywordList >}}

---

## Screenshots

{{< gallery >}}
  <img src="featured.png" class="grid-w50 md:grid-w50" alt="trex brand" />
  <img src="screenshot.png" class="grid-w50 md:grid-w50" alt="trex TUI in action" />
{{< /gallery >}}

---

## GitHub

{{< github repo="blackopsrepl/trex" >}}

---

## Installation

### Cargo {{< badge >}}Recommended{{< /badge >}}

```bash
cargo install trex
```

The easiest way to install trex if you have Rust installed.

### Binary Download

Download the latest release from GitHub:

```bash
# Download
curl -LO https://github.com/blackopsrepl/trex/releases/latest/download/trex-linux-x86_64.tar.gz

# Extract
tar -xzf trex-linux-x86_64.tar.gz

# Install
sudo mv trex /usr/local/bin/
```

{{< alert icon="circle-info" >}}
Pre-built binaries are statically linked for universal Linux compatibility.
{{< /alert >}}

### Build from Source

```bash
git clone https://github.com/blackopsrepl/trex
cd trex
cargo build --release
```

The binary will be at `target/release/trex`.

---

## Quick Start

{{< alert icon="triangle-exclamation" cardColor="#ff6b6b" iconColor="#ffffff" textColor="#ffffff" >}}
**trex must be run from outside tmux.** If you try to run it from within a tmux session, it will exit with an error message.
{{< /alert >}}

```bash
# Just run it
trex
```

That's it. No configuration files needed.

{{< alert icon="lightbulb" cardColor="#1a1a2e" iconColor="#00ff00" textColor="#ffffff" >}}
**Zsh Keybinding** — Add this to your `.zshrc` to launch trex with `Ctrl+T`:

```zsh
trex-widget() {
  zle push-input
  BUFFER="trex"
  zle accept-line
}
zle -N trex-widget
bindkey '^T' trex-widget
```
{{< /alert >}}

---

## Features

{{< timeline >}}

{{< timelineItem icon="list" header="Session Management" badge="Core" subheader="Browse & Control" >}}
Create, attach, delete, and detach tmux sessions with simple keyboard shortcuts. Navigate with vim-like keybindings.
{{< /timelineItem >}}

{{< timelineItem icon="search" header="Fuzzy Search" badge="Fast" subheader="Powered by nucleo" >}}
Quickly filter sessions and directories with fuzzy matching. The same algorithm used by popular fuzzy finders, optimized for speed.
{{< /timelineItem >}}

{{< timelineItem icon="folder" header="Directory Discovery" badge="Smart" subheader="Filesystem Scan" >}}
Discover directories across your filesystem with configurable depth (1-6 levels). Automatically prioritizes your current directory and common project locations.
{{< /timelineItem >}}

{{< timelineItem icon="lightbulb" header="Smart Selection" badge="Context" subheader="Auto-preselect" >}}
Automatically preselects sessions matching your current working directory. First by exact path match, then by directory name.
{{< /timelineItem >}}

{{< /timeline >}}

---

## Keybindings

### Normal Mode

| Key | Action |
|-----|--------|
| `j` / `k` | Navigate down / up |
| `g` / `G` | Jump to first / last |
| `Enter` | Attach to session |
| `c` | Create new session (directory mode) |
| `d` | Delete selected session |
| `D` | Delete all sessions |
| `x` | Detach from selected session |
| `X` | Detach all clients |
| `/` | Enter filter mode |
| `q` / `Esc` | Quit |

### Directory Selection Mode

| Key | Action |
|-----|--------|
| `j` / `k` | Navigate directories |
| `g` / `G` | Jump to first / last |
| `Enter` | Create session in directory |
| `Tab` | Complete filter with path |
| `+` / `-` | Increase / decrease scan depth |
| `Esc` | Cancel and return |

### Filter Mode

| Key | Action |
|-----|--------|
| *Type* | Filter sessions/directories |
| `Backspace` | Delete character |
| `Esc` | Exit filter mode |

---

## Architecture

{{< mermaid >}}
graph TD
    subgraph CLI["trex CLI"]
        A[main.rs]
    end

    subgraph TUI["TUI Module"]
        B[app.rs<br/>State & Logic]
        C[events.rs<br/>Key Handling]
        D[ui.rs<br/>Rendering]
    end

    subgraph TMUX["tmux Integration"]
        E[commands.rs<br/>TmuxClient]
        F[parser.rs<br/>Session Parser]
        G[session.rs<br/>TmuxSession]
    end

    subgraph DISCO["Directory Discovery"]
        H[directory.rs<br/>Filesystem Scan]
    end

    A --> B
    A --> E
    A --> H

    B --> C
    B --> D
    B -.-> |nucleo| I[Fuzzy Matching]

    E --> F
    E --> G

    D -.-> |ratatui| J[Terminal UI]
    D -.-> |crossterm| K[Raw Mode]
{{< /mermaid >}}

---

## Highlights

{{< alert icon="fire" cardColor="#1a1a2e" iconColor="#00ff00" textColor="#ffffff" >}}
**Single binary, zero config** — Just run `trex` and start managing sessions. No configuration files, no setup, no dependencies.
{{< /alert >}}

{{< alert icon="bolt" cardColor="#1a1a2e" iconColor="#ffff00" textColor="#ffffff" >}}
**Blazingly fast** — Written in Rust with the `nucleo` fuzzy matching library. Handles thousands of directories instantly.
{{< /alert >}}

{{< alert icon="shield" cardColor="#1a1a2e" iconColor="#00ffff" textColor="#ffffff" >}}
**Static builds** — Pre-built binaries are statically linked for universal Linux compatibility. No runtime dependencies.
{{< /alert >}}

---

## Tech Stack

{{< keywordList >}}
{{< keyword icon="code" >}} Rust {{< /keyword >}}
{{< keyword icon="code" >}} ratatui {{< /keyword >}}
{{< keyword icon="code" >}} crossterm {{< /keyword >}}
{{< keyword icon="code" >}} nucleo {{< /keyword >}}
{{< keyword icon="code" >}} anyhow {{< /keyword >}}
{{< keyword icon="code" >}} thiserror {{< /keyword >}}
{{< /keywordList >}}

---

## Links

{{< button href="https://github.com/blackopsrepl/trex" target="_blank" >}}
{{< icon "github" >}} View on GitHub
{{< /button >}}

{{< button href="https://github.com/blackopsrepl/trex/releases" target="_blank" >}}
{{< icon "download" >}} Download Releases
{{< /button >}}

{{< button href="https://crates.io/crates/trex" target="_blank" >}}
{{< icon "code" >}} crates.io
{{< /button >}}
