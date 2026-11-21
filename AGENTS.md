# Agent instructions

This repository holds plugin crates for the Ponko game engine
(<https://gitlab.com/ponkoengine/ponko>), one per folder in `crates/`.
Each crate has its own `AGENTS.md` from the engine's plugin template; read it
before changing that crate.

- The engine is a checkout beside this one, `../ponko`.
- `scripts/check.sh` checks everything: run it before every commit.
- A new plugin starts from the template (`ponko new crates/ponko_<thing>
  --plugin`); README.md, "Adding a plugin", lists the steps.
- Never open a window in tests: games run with `run_headless`.
- Use only the engine's public API, never `#[doc(hidden)]` items.
- The engine's guide, "Plugins for other crates"
  (<https://ponko.dev/guide/plugins.html>), has the naming and versioning
  rules.
