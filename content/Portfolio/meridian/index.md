---
title: "Meridian"
date: 2026-08-15
draft: false
description: "An offline native desktop workbench for traditional astrology"
tags: ["Rust", "Desktop", "SQLite", "Offline First", "Native UI"]
showHero: false
showTableOfContents: true
showBreadcrumbs: true
showReadingTime: true
showWordCount: true
---

{{< lead >}}
A serious traditional-astrology workbench that belongs to its user: native, local, and complete without an account or network connection.
{{< /lead >}}

Meridian calculates, inspects, compares, archives, and exports charts using bundled Swiss Ephemeris data and a local city atlas. It is a desktop product rather than a web shell—its calculation engine, archive, resources, and interface travel together on Linux, Windows, and macOS.

{{< keywordList >}}
{{< keyword icon="globe" >}} Fully offline {{< /keyword >}}
{{< keyword icon="chart" >}} Traditional techniques {{< /keyword >}}
{{< keyword icon="database" >}} Private local archive {{< /keyword >}}
{{< keyword icon="search" >}} Bundled city atlas {{< /keyword >}}
{{< keyword icon="desktop" >}} Native packages {{< /keyword >}}
{{< /keywordList >}}

## The workspace

The chart wheel and inspector are one interactive surface: selecting a planet, aspect, sign, house, angle, or lot highlights every connected element and exposes its exact data. The remaining workspaces keep creation, research, timing, comparison, and retrieval close at hand.

{{< gallery >}}
  <img src="chart-workspace.png" class="grid-w50 md:grid-w50" loading="lazy" decoding="async" alt="Meridian chart workspace with a selected house and inspector" />
  <img src="new-chart.png" class="grid-w50 md:grid-w50" loading="lazy" decoding="async" alt="Meridian new chart window with local time and place inputs" />
  <img src="ephemeris.png" class="grid-w50 md:grid-w50" loading="lazy" decoding="async" alt="Meridian planetary ephemeris and ingress table" />
{{< /gallery >}}

## One application, several serious workflows

{{< timeline >}}

{{< timelineItem icon="chart" header="Calculate and inspect" badge="Core" subheader="Natal, event, horary, mundane, and electional charts" >}}
The resizable wheel, positions list, and inspector expose the same immutable calculated chart. Whole Sign, Equal, Porphyry, Alcabitius, Placidus, Regiomontanus, Campanus, and Morinus houses are available.
{{< /timelineItem >}}

{{< timelineItem icon="clock" header="Research through time" badge="Timing" subheader="Techniques that stay connected to the open chart" >}}
Transits, secondary progressions, solar arcs, harmonics, profections, firdaria, returns, planetary hours, and bounded election searches share the same local calculation layer.
{{< /timelineItem >}}

{{< timelineItem icon="people" header="Compare charts" badge="Relationships" subheader="Synastry, midpoint composite, and Davison methods" >}}
Relationship work produces an inspectable comparison and can export its result as SVG, alongside the application’s chart-document and CSV workflows.
{{< /timelineItem >}}

{{< timelineItem icon="archive" header="Keep a private archive" badge="Local" subheader="SQLite persistence with portable chart documents" >}}
New calculations enter a local archive automatically. A `.meridian` document remains editable and portable; SVG and CSV are explicit exports rather than lossy substitutes for the chart.
{{< /timelineItem >}}

{{< /timeline >}}

## Calculation integrity

{{< alert icon="circle-info" >}}
Meridian reports missing precision data as an error. It does not silently substitute an analytical ephemeris or call a remote service.
{{< /alert >}}

Civil times use IANA historical time-zone rules. Ambiguous local times require an explicit fold; nonexistent times are rejected. The calculation surface includes apparent tropical geocentric positions, traditional aspects and orbs, dignity, reception, sect, lots, antiscia, dodecatemoria, and planetary days and hours.

{{< mermaid >}}
flowchart LR
    input[Local date, time, and place] --> time[IANA time-zone resolution]
    time --> calc[Swiss Ephemeris calculation]
    calc --> chart[Immutable calculated chart]
    chart --> wheel[Interactive workspace]
    chart --> archive[SQLite archive]
    chart --> export[Meridian / SVG / CSV]
{{< /mermaid >}}

## Native delivery

The same offline data set is packaged into AppImage, DEB, RPM, Windows installer, and universal macOS DMG builds. A companion CLI accepts a JSON request and emits JSON, SVG, or CSV through the same calculation model used by the desktop application.

## Repository

{{< github repo="blackopsrepl/meridian" showThumbnail=false >}}

{{< button href="https://github.com/blackopsrepl/meridian/releases/latest" target="_blank" >}}
{{< icon "download" >}} Download Meridian
{{< /button >}}
