---
title: "Meridian"
date: 2026-08-15
draft: false
description: "An offline native desktop workbench for traditional astrology"
tags: ["Rust", "Desktop", "SQLite", "Offline First", "Native UI"]
showHero: false
showTableOfContents: true
---

{{< lead >}}
Meridian is a local, native desktop application for calculating, inspecting, and archiving traditional astrological charts—without a browser account, remote service, or network dependency.
{{< /lead >}}

## A real desktop product

The application combines a responsive chart workspace, local SQLite archive, city atlas, ephemeris tables, timing techniques, relationship charts, election searches, and SVG/CSV export. It ships as native packages for Linux, Windows, and macOS.

{{< keywordList >}}
{{< keyword icon="globe" >}} Fully offline {{< /keyword >}}
{{< keyword icon="chart" >}} Traditional techniques {{< /keyword >}}
{{< keyword icon="database" >}} Private local archive {{< /keyword >}}
{{< keyword icon="desktop" >}} Three-platform packaging {{< /keyword >}}
{{< /keywordList >}}

## Calculation integrity

Meridian uses bundled Swiss Ephemeris data and IANA historical time-zone rules. Missing precision data is reported as an error; it does not quietly replace the calculation with an approximation or web lookup. Ambiguous civil times require an explicit choice and impossible local times are rejected.

## Links

{{< button href="https://github.com/blackopsrepl/meridian" target="_blank" >}}
{{< icon "github" >}} Source and downloads
{{< /button >}}
