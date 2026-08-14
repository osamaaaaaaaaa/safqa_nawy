# Safqa

React landing foundation for a verified real estate transfer and freelance broker closing platform.

## Project Rules

- All visible copy must live in `src/i18n/locales/ar.ts` and `src/i18n/locales/en.ts`.
- Fixed brand data must live in `src/config/brand.ts`.
- Images and asset keys must live in `src/config/assets.ts`.
- Mobile is a dedicated experience through `MobileLanding`, selected by `useViewportMode`.
- Desktop is a separate experience through `DesktopLanding`.
- Components should stay small and scoped to their feature folder.
- Run `npm.cmd run build` and `npm.cmd run lint` before handing off changes.

## Structure

```text
src/
  config/
    assets.ts
    brand.ts
  features/
    landing/
      LandingPage.tsx
      components/
        DesktopLanding.tsx
        MobileLanding.tsx
  hooks/
    useViewportMode.ts
  i18n/
    locales/
      ar.ts
      en.ts
    index.ts
    types.ts
```

## Commands

```bash
npm.cmd install
npm.cmd run dev
npm.cmd run build
npm.cmd run lint
```
