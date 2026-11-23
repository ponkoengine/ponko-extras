# Ponko extras

Plugins for the [Ponko](https://github.com/ponkoengine/ponko) game engine
that the project maintains outside the engine. Each one is a crate in
`crates/`, made from the engine's plugin template, and follows the guide's
[Plugins for other crates](https://ponko.dev/guide/plugins.html): the names,
the versions and the tests.

| Crate | What it adds | Ponko |
|---|---|---|
| [`ponko_pulse`](crates/ponko_pulse) | The template's own plugin, kept as the reference every check builds: a `Pulse` component, its system, a debug toggle and a control method | main |

## Adding a plugin

1. Make the crate from the engine's template, in `crates/`, named
   `ponko_<thing>` (the `ponko_` prefix is the project's; other people's
   plugins use their own names):

   ```sh
   ponko new crates/ponko_weather --plugin
   ```

   Without the `ponko` command line tool, the same template works with
   cargo-generate:
   `cargo generate --git https://github.com/ponkoengine/ponko crates/ponko_cli/templates/plugin --destination crates --name ponko_weather`.

2. Make it a member of this workspace, as `crates/ponko_pulse/Cargo.toml`
   shows: `edition`, `license` and `repository` with `.workspace = true`,
   `ponko = { workspace = true }` instead of its own engine line (add
   `features = [...]` only for the engine features the code needs) and
   `serde = { workspace = true }`. Delete its `[profile.*]` sections and its
   `.gitignore`: the root has them.

3. Replace the template's `Pulse` with the plugin, keeping what the
   template checks: headless tests in `tests/` (one game per test, run with
   `run_headless`), the test that adding the plugin twice fails, and
   everything it adds to a game named after the crate
   (`ponko_weather.clouds`, `ponko_weather.set_rain`).

4. Fill in its README: the table of what it adds, and the `## Versions`
   table (this crate's version to the Ponko versions it works with). Add
   its row to the table above.

5. Check it (below), then open a merge request.

## Checking

The crates build against an engine checkout beside this repository,
`../ponko` (a symbolic link works), on the engine's `main` branch:

```sh
git clone https://github.com/ponkoengine/ponko ../ponko   # once
scripts/check.sh
```

It checks every crate's layout (the `ponko_` name, the workspace engine
dependency, no profiles of its own, a README with a versions table, an
AGENTS.md, headless tests), then `cargo fmt --check`, `cargo clippy
--all-targets -D warnings` and `cargo test` over the workspace. Tests never
open a window. A plugin that needs an engine change that isn't merged yet
builds against `../ponko` on that change's branch.

## Versions

Until the engine is on crates.io, every crate builds against the engine
checkout beside this one, on its `main` branch (the root `Cargo.toml`).
After that:

- Each crate follows semver on its own. A breaking change is a new minor
  version before 1.0 (0.1 to 0.2), a new major one after.
- The workspace depends on a Ponko minor (`version = "0.1"`), never an exact
  patch. A new Ponko minor is a new minor (or major) release of every crate
  here, because their APIs carry Ponko's types; the old line keeps getting
  fixes while games move.
- Each crate's README says which of its versions go with which Ponko
  versions.

## License

MIT or Apache-2.0, at your option, like the engine.
