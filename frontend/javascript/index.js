const byId = (id) => document.getElementById(id);

const escapeHtml = (value) =>
  String(value ?? "").replace(/[&<>"']/g, (character) => ({
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#039;",
  })[character]);

const setupMenu = () => {
  const button = byId("menu-button");
  const wrapper = byId("menu-wrapper");
  const closeButton = byId("menu-close-button");
  if (!button || !wrapper) return;

  const setOpen = (open) => {
    wrapper.classList.toggle("is-open", open);
    button.setAttribute("aria-expanded", String(open));
    wrapper.setAttribute("aria-hidden", String(!open));
    document.body.classList.toggle("menu-open", open);
  };

  button.addEventListener("click", () => setOpen(!wrapper.classList.contains("is-open")));
  closeButton?.addEventListener("click", (event) => {
    event.stopPropagation();
    setOpen(false);
  });
  wrapper.querySelectorAll("a").forEach((link) => link.addEventListener("click", () => setOpen(false)));
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") setOpen(false);
  });
};

const setupSearch = () => {
  const wrapper = byId("search-wrapper");
  const modal = byId("search-modal");
  const input = byId("search-query");
  const output = byId("search-results");
  const buttons = [byId("search-button"), byId("search-button-mobile")].filter(Boolean);
  const closeButton = byId("close-search-button");
  if (!wrapper || !modal || !input || !output || buttons.length === 0 || !closeButton) return;

  let entries = [];
  let indexPromise;

  const loadIndex = () => {
    indexPromise ??= fetch("/index.json").then((response) => response.json()).then((data) => {
      entries = data;
      return entries;
    });
    return indexPromise;
  };

  const renderResults = (query) => {
    const terms = query.toLowerCase().trim().split(/\s+/).filter(Boolean);
    output.replaceChildren();
    if (terms.length === 0) return;

    const results = entries
      .map((entry) => {
        const title = entry.title.toLowerCase();
        const text = [entry.title, entry.section, entry.summary, entry.content].join(" ").toLowerCase();
        const matches = terms.filter((term) => text.includes(term));
        if (matches.length !== terms.length) return null;
        const score = matches.reduce((total, term) => total + (title.includes(term) ? 3 : 1), 0);
        return { entry, score };
      })
      .filter(Boolean)
      .sort((left, right) => right.score - left.score || left.entry.title.localeCompare(right.entry.title))
      .slice(0, 20);

    results.forEach(({ entry }) => {
      const item = document.createElement("li");
      item.className = "search-result";
      const link = document.createElement("a");
      link.className = "search-result-link";
       link.href = entry.external_url || entry.permalink;
       if (entry.external_url) {
        link.target = "_blank";
        link.rel = "noopener";
      }
      link.innerHTML = `<strong>${escapeHtml(entry.title)}</strong><span>${escapeHtml(entry.section)} &middot; ${escapeHtml(entry.date || "")}</span><em>${escapeHtml(entry.summary || "")}</em><b>&rarr;</b>`;
      item.append(link);
      output.append(item);
    });
  };

  const close = () => {
    wrapper.classList.remove("is-open");
    document.body.classList.remove("search-open");
    input.value = "";
    output.replaceChildren();
  };

  const open = () => {
    wrapper.classList.add("is-open");
    document.body.classList.add("search-open");
    input.focus();
    loadIndex().catch(() => {
      output.textContent = "Search is temporarily unavailable.";
    });
  };

  buttons.forEach((button) => button.addEventListener("click", open));
  closeButton.addEventListener("click", close);
  wrapper.addEventListener("click", (event) => {
    if (event.target === wrapper) close();
  });
  modal.addEventListener("click", (event) => event.stopPropagation());
  input.addEventListener("input", () => renderResults(input.value));
  input.form?.addEventListener("submit", (event) => event.preventDefault());
  document.addEventListener("keydown", (event) => {
    if (event.key === "/" && document.activeElement !== input && !wrapper.classList.contains("is-open")) {
      event.preventDefault();
      open();
    }
    if (event.key === "Escape") close();
  });
};

const setupScrollToTop = () => {
  const control = byId("scroll-to-top");
  if (!control) return;
  const update = () => control.classList.toggle("is-visible", window.scrollY > 320);
  window.addEventListener("scroll", update, { passive: true });
  update();
};

const setupEnhancements = () => {
  document.documentElement.classList.add("js-enhanced");
  document.querySelectorAll("[data-reveal]").forEach((element) => element.classList.add("is-visible"));
  if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

  const canvas = document.createElement("canvas");
  canvas.id = "matrix-rain";
  document.body.append(canvas);
  const context = canvas.getContext("2d");
  const characters = "01アイウエオカキクケコサシスセソタチツテトナニヌネノ";
  const fontSize = 12;
  let columns = 0;
  let drops = [];

  const resize = () => {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    columns = Math.floor(canvas.width / (fontSize * 2.5));
    drops = Array(columns).fill(1);
  };

  const draw = () => {
    context.fillStyle = "rgba(0, 0, 0, 0.025)";
    context.fillRect(0, 0, canvas.width, canvas.height);
    context.fillStyle = "#00ff41";
    context.font = `${fontSize}px monospace`;
    drops.forEach((drop, index) => {
      if (Math.random() > 0.92) {
        const character = characters[Math.floor(Math.random() * characters.length)];
        context.fillText(character, index * fontSize * 2.5, drop * fontSize);
      }
      drops[index] = drop * fontSize > canvas.height && Math.random() > 0.985 ? 0 : drop + 1;
    });
  };

  resize();
  window.addEventListener("resize", resize);
  window.setInterval(draw, 80);
};

document.addEventListener("DOMContentLoaded", () => {
  setupMenu();
  setupSearch();
  setupScrollToTop();
  setupEnhancements();
  if (window.mermaid) {
    if (typeof window.initMermaidDark === "function") window.initMermaidDark();
    window.mermaid.run();
  }
});
