# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Single-page website for "Improving Groundwater Management in the Jaffna Peninsula" — a research/development project. The entire site lives in one file: `index.html` (~1586 lines of inline HTML, CSS, and JavaScript).

No build system, package manager, or dev server. Open `index.html` directly in a browser to preview.

## Architecture

- **Single-file**: All markup, styles, and scripts are in `index.html`
  - Lines ~1–10: Head/meta/fonts
  - Lines ~10–790: `<style>` block (CSS custom properties, components, responsive breakpoints)
  - Lines ~790–870: Responsive breakpoints at 1024px, 768px, 480px
  - Lines ~880–1440: HTML sections: Preloader → Hero → About → Partners → Timeline → Gallery → Team → Footer
  - Lines ~1440–1586: `<script>` block (scroll observers, animations, lightbox, smooth scroll)
- **Design reference**: Inspired by wanaka.studio editorial aesthetic

## Design System

### Colors (CSS custom properties on `:root`)
| Token        | Value     | Usage                              |
|--------------|-----------|------------------------------------|
| `--cream`    | `#F2F0E4` | Primary background (60%)           |
| `--black`    | `#000000` | Text, dark sections (30%)          |
| `--orange`   | `#F25C05` | Accent — CTA button only (10%)     |

Additional tokens: `--orange-hover` (`#d94f00`), `--orange-light`, gray scale (`--gray-100` through `--gray-900`), text variants (`--text-primary`, `--text-secondary`, `--text-muted`).

Orange is intentionally minimal. Most UI elements (timeline nodes, labels, borders) use black/gray. Do not increase orange usage without explicit request.

### Typography
- **Body**: `Inter` (Google Fonts) — weights 300–900
- **Display/Emphasis**: `Playfair Display` italic — used for hero highlight words and editorial accents
- **Easing**: Three curves available — `--ease-smooth` (signature, Wanaka-style), `--ease-out-expo`, `--ease-out-quart`

## Key Patterns

### Timeline Alignment
Timeline uses flex layout with `.from-left` / `.from-right` classes (not `:nth-child`). Critical math:
```css
.timeline-content { max-width: calc(50% - 24px); }
.timeline-spacer  { max-width: calc(50% - 24px); }
.timeline-entry   { gap: 48px; }
/* Total: calc(50%-24px) + 48px + calc(50%-24px) = 100% */
```
Changing gap or max-width requires recalculating both to sum to 100%.

### SVG Line Draw Animations
Wanaka-style stroke animations using `stroke-dasharray` / `stroke-dashoffset` with IntersectionObserver:
```css
.svg-line-draw path { stroke-dasharray: 500; stroke-dashoffset: 500; }
.svg-line-draw.visible path { stroke-dashoffset: 0; }
```
Use `.light` modifier for white strokes on dark backgrounds.

### Scroll Animations
- IntersectionObserver triggers `.visible` class on elements entering viewport
- Hero text uses line-by-line staggered reveal
- Timeline has a scroll-fill effect (black line grows as user scrolls)
- Stat counters animate with `requestAnimationFrame`

### Navigation
Uses `mix-blend-mode: difference` to remain visible over the dark hero section. Mobile nav (≤768px) uses a hamburger menu with a full-screen slide-in overlay.

### Responsive Breakpoints
Three breakpoints: `1024px` (tablet), `768px` (mobile nav + layout), `480px` (small phone). SVG decorations are hidden at ≤1024px. Gallery and team grids collapse progressively.

### Lightbox
Gallery items open in a lightbox overlay. Close via button, clicking outside, or pressing Escape.

### JavaScript Structure (~1440–1586)
- **Preloader**: hides on `window.load`, reveals hero
- **Scroll**: nav gets `.scrolled` class on scroll, timeline fill tracks scroll position
- **IntersectionObservers**: three separate observers for `.reveal` elements, `.svg-line-draw` animations, and `.stat-number` counters
- **Lightbox**: click-to-open gallery, close via button/overlay/Escape
- **Smooth scroll**: anchor links use `scrollIntoView`
