# AGENTS.md

## Overview

This repository contains an ESPHome-based Home Assistant interface panel for the Waveshare ESP32-S3-Touch-LCD-3.5B board.

- Treat [main.yaml](./main.yaml) as the reusable package entrypoint for real hardware.
- Treat [dev-sdl.yaml](./dev-sdl.yaml) as the fastest development loop for UI work on a Linux workstation.
- Treat [self-contained.yaml](./self-contained.yaml) as a historical standalone experiment unless a task explicitly targets it.

## Validate Changes

- Run `make test-local` for UI/layout work; it renders via ESPHome SDL without reflashing hardware.
- Run `make test-validate` to validate the SDL configuration.
- Run `esphome config example-instance.yaml` when changing package inputs or installation-facing behavior, because CI builds that file in [build.yaml](./.github/workflows/build.yaml).
- Use `make flash-main` or `make upload-main` only for actual device deployment. The default target assumes OTA; set `LOCALLY_ATTACHED=1` for USB flashing.

## Repo Map

- [main.yaml](./main.yaml): production package, substitutions, Wi-Fi/API/web server, and package includes.
- [include/](./include/): the real implementation surface. Most functional changes belong here.
- [include/hw_waveshare-esp32-s3-touch-lcd-3.5b.yaml](./include/hw_waveshare-esp32-s3-touch-lcd-3.5b.yaml): board buses, display, touch controller, backlight, PSRAM.
- [include/lvgl_page_main.yaml](./include/lvgl_page_main.yaml): top-level LVGL page and tabs.
- [include/lvgl_tab_*.yaml](./include/): tab-specific UI slices.
- [example-instance.yaml](./example-instance.yaml) and [interface-panel-p*.yaml](./): consumer configs that pull this repo as a remote package.
- [docs/electronics.md](./docs/electronics.md), [docs/mechanical.md](./docs/mechanical.md), and [docs/mechanical-install.md](./docs/mechanical-install.md): hardware and installation background. Link to them instead of copying details.

## Project Conventions

- Prefer small YAML package edits over duplicating config blocks across entrypoints.
- Use 2-spaces indentation in YAML files
- Keep [main.yaml](./main.yaml) and [dev-sdl.yaml](./dev-sdl.yaml) aligned for shared substitutions, colors, fonts, and UI behavior unless the difference is strictly hardware-specific.
- Put hardware-specific changes in [include/hw_waveshare-esp32-s3-touch-lcd-3.5b.yaml](./include/hw_waveshare-esp32-s3-touch-lcd-3.5b.yaml) or [include/hw_sdl.yaml](./include/hw_sdl.yaml), not in LVGL page files.
- Keep secrets and deployment-specific values in consumer configs or `secrets.yaml`; do not hardcode real credentials in package files.
- Preserve the package-consumer model used in [example-instance.yaml](./example-instance.yaml): users are expected to override `esphome.name`, `friendly_name`, and secret substitutions from outside the package.

## Pitfalls

- Display orientation is controlled by the `display_rotation` substitution in [main.yaml](./main.yaml) and [dev-sdl.yaml](./dev-sdl.yaml). If orientation changes, verify touch alignment and widget coordinates together.
- UI geometry is largely hard-coded for a 480x320 landscape layout in [include/lvgl_page_main.yaml](./include/lvgl_page_main.yaml) and related include files. Screen size or rotation changes usually require coordinated edits across multiple LVGL fragments.
- CI validates [example-instance.yaml](./example-instance.yaml), not the SDL config. A change that only works in SDL is incomplete.

## When Editing

- Start from the nearest include file that owns the behavior instead of editing top-level wiring first.
- For UI issues, inspect the specific tab/widget include before changing shared theme or hardware files.
- For hardware/touch/display issues, check both the display/touch declarations and the substitutions that feed them.