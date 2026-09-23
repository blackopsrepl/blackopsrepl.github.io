---
title: "Franking"
date: 2026-03-09
draft: false
description: "A spiffy ratatui TUI email client with an app-owned IMAP/SMTP engine"
tags: ["Rust", "CLI", "TUI", "Email", "Developer Tools"]
---

<div class="lead"><p>A terminal email client that owns its mail layer—native IMAP/SMTP transport, a local SQLite store, and a keyboard-driven workflow built for real triage.</p></div>

Franking is a ratatui TUI email client with an app-owned mail layer. Accounts, endpoints, auth bindings, and secret references live in SQLite; raw secrets stay in the OS keyring. A shared MIME parser produces one canonical view of a message, and a background worker pool keeps every mail operation off the render path.

<div class="keyword-list"><span class="keyword-pill"><img class="inline-icon" src="/icons/envelope.svg" alt="" width="16" height="16">Native IMAP/SMTP</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/list.svg" alt="" width="16" height="16">Local SQLite store</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/lock.svg" alt="" width="16" height="16">PGP &amp; S/MIME</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/globe.svg" alt="" width="16" height="16">Multi-account</span>
<span class="keyword-pill"><img class="inline-icon" src="/icons/code.svg" alt="" width="16" height="16">Ratatui TUI</span></div>

## Built for triage, not just reading

<div class="timeline"><article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/list.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Folders and messages</h3><span class="timeline-badge">Core</span><p class="timeline-subheader">Unread counts, per-account folders, threaded or flat</p></header>
    <div class="timeline-item-body"><p>Server-side ordering with a local cache, relative timestamps, mouse support, and an "All Inboxes" folder that merges every account's inbox when more than one is configured.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/eye.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Reader</h3><span class="timeline-badge">MIME</span><p class="timeline-subheader">Structured content, attachments, invitations</p></header>
    <div class="timeline-item-body"><p>Raw messages are parsed once and rendered as structured content with one canonical HTML-first path. Attachments preview in place, save individually, or write out as an archive, and <code>text/calendar</code> events show their summary and timezone and can be handed to Planner123.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/edit.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Compose</h3><span class="timeline-badge">Authoring</span><p class="timeline-subheader">Reply, forward, attachments, drafts</p></header>
    <div class="timeline-item-body"><p>A single authoritative input router resolves focus buckets, popups, and shortcuts in a deterministic precedence order, so modal interactions stay predictable. PGP and S/MIME toggles sit beside snippets, in-body search, and save-as-draft.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/tag.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Triage lanes</h3><span class="timeline-badge">Workflow</span><p class="timeline-subheader">Screening, follow-up, quiet conversations</p></header>
    <div class="timeline-item-body"><p>An inbox cycles through Screening, Inbox, Reading, Receipts, and Blocked, and <code>1</code>–<code>5</code> routes a sender for the receiving account. Follow-up queues, quiet and resurfacing timers, local annotations, sender bundles, and workflow stages keep a high-volume mailbox operable without leaving the keyboard.</p></div>
  </div>
</article>


<article class="timeline-item">
  <div class="timeline-item-icon"><img class="inline-icon" src="/icons/lock.svg" alt="" width="16" height="16"></div>
  <div class="timeline-item-card">
    <header><h3>Accounts and secrets</h3><span class="timeline-badge">Trust</span><p class="timeline-subheader">Discovery, SQLite metadata, OS keyring</p></header>
    <div class="timeline-item-body"><p>Add an account by email: Google, iCloud, and Outlook presets, then Mozilla autoconfig, Microsoft Autodiscover, and RFC 6186 SRV. SQLite stores definitions, endpoints, auth bindings, and secret references; the raw secrets stay in the OS keyring. Versioned migrations preserve local decisions and fail safely on an unsupported database.</p></div>
  </div>
</article></div>

## Screenshots

Every image below is the running application, rendered from its own cell grid with the colours it chose.

<div class="gallery"><img src="envelope-list.png" loading="lazy" decoding="async" alt="Folder list and envelope list with unread counts" />
<img src="message-view.png" loading="lazy" decoding="async" alt="Message reader with attachments and a calendar invitation" />
<img src="compose.png" loading="lazy" decoding="async" alt="Composing a reply with PGP and S/MIME toggles" />
<img src="search.png" loading="lazy" decoding="async" alt="Search with a scope selector cycling folder, all folders, and all accounts" /></div>

## Architecture

<pre class="not-prose mermaid">graph TD
    TUI[Ratatui TUI - Elm architecture] --&gt; Worker[Async worker pool]
    Worker --&gt; Service[MailService trait]
    Service --&gt; IMAP[Native IMAP]
    Service --&gt; SMTP[Native SMTP]
    Service --&gt; Maildir[Local maildir]
    Service --&gt; DB[(SQLite: accounts, contacts, identities)]
    Service --&gt; Keyring[OS keyring: secrets]
    Service --&gt; MIME[Shared MIME parser]</pre>

## An app-owned mail layer

<aside class="alert"><p>Franking does not wrap a system mail client. It owns the account store, the MIME parser, the crypto keyring, and the transport, so behaviour is explicit and testable end to end.</p></aside>

OpenPGP (inline and PGP/MIME) and S/MIME (PKCS#7 signed and enveloped) verify and decrypt against a local keyring, and SPF, DKIM, and DMARC verdicts are surfaced from <code>Authentication-Results</code>. Live integration tests run Dovecot and Mailpit in throwaway containers, and the local <code>test</code> maildir account works with no network and no external dependencies.

## Repository

<div class="github-card"><a href="https://github.com/blackopsrepl/Franking">blackopsrepl/Franking</a></div>

<a class="button" href="https://github.com/blackopsrepl/Franking" target="_blank"><img class="inline-icon" src="/icons/github.svg" alt="" width="16" height="16" /> Source and setup</a>
