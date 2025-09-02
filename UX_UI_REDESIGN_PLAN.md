# VisitMeet 2025 UI/UX Redesign Plan

## 1. Goals
- Deliver a joyful, elegant, bold interface that reflects VisitMeet's mission of discovery, connection and exploration.
- Make the experience mobile‑first and fully responsive.
- Improve perceived performance with lightweight assets, lazy loading and meaningful loading states.
- Introduce a coherent design system with reusable components and micro‑interactions.

## 2. Audit Summary
- **Visual noise** – heavy gradients and mixed typography compete for attention.
- **Inconsistent spacing** – layouts use ad‑hoc margins/padding, making hierarchy unclear.
- **Inline scripts** in views (e.g. `app/views/home/index.html.erb`) couple logic and markup, hindering reuse and causing slow page loads.
- **Limited mobile optimisation** – forms and buttons stretch awkwardly on small screens; some elements overflow.
- **Missing feedback** – form submissions and long requests lack skeletons or progress indicators.

## 3. Design System Outline
| Element | Recommendation |
| --- | --- |
| **Color palette** | Neutral warm gray for backgrounds, vibrant accent (indigo→emerald) reserved for CTAs.
| **Typography** | Variable font pairing: Inter for body, Fraunces for headings. Scale defined by Tailwind `text-` utilities.
| **Spacing** | 8‑point scale (`2, 4, 8, 16…`) enforced through Tailwind config to ensure rhythm.
| **Components** | Buttons, cards, navigation bars, inputs and dialogs built as Rails partials with Stimulus controllers.
| **Icons/Illustrations** | Feather icons and lightweight Lottie animations for empty states.

## 4. Interaction Principles
- Sub‑200 ms transitions; use Tailwind `transition` utilities and Stimulus for enter/leave animations.
- Micro‑interaction examples:
  - Button press ripple using `@keyframes`.
  - Lazy‑loaded images fading in (`loading="lazy"` + opacity transition).
  - Skeleton placeholders for results lists.
- Keyboard and screen‑reader friendly: `aria` labels, focus outlines, logical tab order.

## 5. Implementation Roadmap
1. **Establish base layout** – refactor `app/views/layouts` to define responsive grid, header/footer partials.
2. **Extract scripts** – move inline JS into ES modules under `app/javascript/custom` and register Stimulus controllers.
3. **Component library** – create `app/views/components` with partials for cards, buttons and forms using the new Tailwind config.
4. **Page by page redesign** – start with authentication (Sign In/Sign Up) ➜ Home ➜ Offerings ➜ Bookings ➜ Profiles, ensuring each uses components.
5. **Performance & accessibility pass** – audit with Lighthouse/axe, add loading states and lazy assets.

## 6. Next Steps
- Iterate with design mockups (Figma or similar) before implementing.
- Coordinate with product/designer for visual assets and color decisions.
- After components are stable, update documentation and write integration tests for key flows.

---
This plan serves as the foundation for a full 2025‑ready redesign. Each step can be tackled incrementally while keeping the application functional.

