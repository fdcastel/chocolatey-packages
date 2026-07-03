# chocolatey-packages

[Chocolatey](https://chocolatey.org/) packages maintained by me.

## Packages

| Package | Description | Updates |
| --- | --- | --- |
| [clickhouse-odbc](clickhouse-odbc/) | ClickHouse ODBC driver | ChocoForge |
| [firebird](firebird/) | Firebird database server (v3 / v4 / v5) | ChocoForge |
| [firebird-odbc](firebird-odbc/) | Firebird ODBC driver | ChocoForge |
| [opkssh](opkssh/) | opkssh — SSH access via OpenID Connect (OpenPubkey) | ChocoForge |
| [qemu-img](qemu-img/) | QEMU disk image utility | ChocoForge |
| [msodbcsql](msodbcsql/) | Microsoft ODBC Driver 18 for SQL Server | Manual |
| [msoledbsql](msoledbsql/) | Microsoft OLE DB Driver for SQL Server | Manual |

## Automation — ChocoForge

Most packages are updated and published automatically by
[ChocoForge](https://www.powershellgallery.com/packages/ChocoForge), a PowerShell module (by the
same author) that turns a small config file into a built-and-published Chocolatey package.

The [`update-all-packages`](.github/workflows/update-all-packages.yml) GitHub Actions workflow runs
daily (and on demand). It installs ChocoForge and runs `Sync-ForgePackage` against every
`*.forge.yaml` in the repo. For each package, ChocoForge:

1. Reads the upstream **GitHub releases** declared in `releases.source` and extracts versions/assets
   using the `versionPattern` / `assetsPattern` regexes.
2. Compares them against the versions already published on each configured feed to find what's
   missing.
3. Builds any missing version from templates — the `.nuspec` and `tools/` scripts use placeholders
   such as `{{version}}`, `{{assets.x64.browser_download_url}}`, and `{{assets.x64.sha256}}` (and
   can embed the installer inside the package, as `firebird-odbc` does).
4. Publishes the new versions to the package's `sources` — the Chocolatey Community Repository,
   GitHub Packages, and/or GitLab.

Each automated package is therefore just three things: a `*.forge.yaml`, a templated `*.nuspec`, and
a `tools/` folder of templated install scripts.

## Microsoft driver packages (manually maintained)

`msodbcsql` and `msoledbsql` are the two exceptions — they are still updated by hand.

ChocoForge can only track versions from **GitHub releases**. Microsoft distributes these drivers
through `download.microsoft.com` and publishes their version history only on the Microsoft Learn
release-notes pages — there are no GitHub releases, tags, or any other machine-readable feed for
ChocoForge to watch. Until ChocoForge gains a non-GitHub release source (or the drivers are mirrored
into a GitHub "repack" repository, the way `qemu-img` and `firebird-odbc` are), updating them means
editing the `version` in the `.nuspec` and swapping the download URLs + SHA-256 checksums in
`tools/chocolateyinstall.ps1` by hand, then packing and pushing.
