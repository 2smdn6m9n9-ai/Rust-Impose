# Rust Impose for Apple Silicon

**Version 0.1.2 · Native macOS app · Rust PDF imposition engine and Rust `egui` desktop interface**

Rust Impose is a local, standalone PDF imposition workstation inspired by the general workflow of Fiery Impose. It is **not** an EFI/Fiery product and does not connect to Fiery Command WorkStation.

## Full portable Apple Silicon application — build and install

**For using the finished app:** Apple Silicon Mac (M1 or newer), macOS 13 or later. **No Rust, Xcode, Homebrew or other installer needed.** This ZIP is source and a build tool, **not a precompiled app**. To obtain a ready-to-install `.dmg` without changing your Mac, run the included GitHub Actions workflow on an Apple Silicon runner (see `GET_THE_APP.md`). If you build locally, the included build script will install missing Rust/Cargo automatically; Apple may request approval for Command Line Tools.

1. Extract the supplied `RustImposeMac_AppleSilicon_AutoBuild_v0.1.2.zip` on your **Mac**.
2. Right-click **`BUILD_MAC.command`** → **Open**, or run `bash BUILD_MAC.command` in Terminal from the extracted folder. This version automatically finds or installs Rust and Cargo on the **build Mac**. If Apple's Command Line Tools are missing, macOS opens its official installer; approve it, finish installation, then reopen `BUILD_MAC.command`.
3. The script runs Rust tests, builds an **ARM64** Rust release executable, compiles the bundled **Apple PDFKit thumbnail helper**, creates a complete macOS `.app`, signs and verifies it, and generates **ZIP and DMG** distributions.
4. Open **`dist/Rust Impose.app`**. You can drag the `.app` to **Applications**. It does **not** require a server, Rosetta, a PDFium download, Docker or a Fiery controller.

**This downloadable project is source code and an automated Mac build workflow, not a precompiled application.** The GitHub workflow creates a distributable `.dmg` and `.zip` on a native Mac runner. Once produced, the `.app` is self-contained and does not require Rust or Xcode on the machine where it is installed. Without Developer ID signing and notarisation, Gatekeeper may require first-launch approval. No OS restarts or system service changes are made.

### Daily use

- Drag a PDF from Finder into the app, or use **Add PDFs** (multiple files accepted).
- Use **Up / Down / Remove** to change the document sequence.
- Choose **Gang-up unique**, **Gang-up repeat**, **Cut & stack**, or **Saddle-stitch booklet**.
- Set paper (A0–A4, SRA3, SRA2, Letter, Tabloid, custom), orientation, rows and columns, sheet margins, inter-page gap, scaling, auto-rotate, and crop marks.
- Navigate imposed sheet sides with **Previous / Next**. PDF previews are rendered locally by macOS PDFKit.
- **Export print-ready PDF** generates the imposed PDF. Use **Save job** and **Load job** for reusable JSON settings (including source file paths).
- Keyboard shortcuts: **Command+O** opens files, **Command+E** exports.

### Layouts

| Mode | Output logic |
|---|---|
| Gang-up unique | Source pages flow left-to-right, top-to-bottom, sheet after sheet. |
| Gang-up repeat | Each source page fills a separate output sheet. |
| Cut & stack | Sequence is arranged for cutting identical position stacks from each sheet and stacking them in cell order. |
| Saddle-stitch booklet | 2-up; auto pads to multiples of four; outputs front/back pairs from outermost to innermost signatures. |

For booklet duplex printing, confirm your machine's **short-edge/long-edge flip** and sheet feed orientation with a physical proof. The optional **Rotate reverse sides 180°** setting can correct the back side for certain workflows. **Creep (mm)** makes a progressively larger inward shift toward the spine for inner sheets. Test on your paper stock.

### PDF fidelity

The exporter constructs PDF **Form XObjects** from the original PDF page streams and recursively copies their referenced resources, including embedded fonts, images and nested forms. It is intended to retain vector text and artwork; it does **not intentionally rasterise** document pages. PDFKit rasterises only the on-screen thumbnail.

**Important limits in v0.1:**

- No Fiery printer integration, JDF job tickets, media catalogue, hot folders, VDP records, mixed-media finishing or automatic preflight/certification.
- Original annotations, interactive form fields, links and live PDF layer controls are **not** retained as interactive annotations/controls. If your job contains live form fields, flatten them before imposing.
- The chosen **CropBox** bounds are treated as the finish cell and are clipped to the cell. A separate **bleed/TrimBox/BleedBox workflow is not implemented yet**. Prepare the artwork to the intended printable boundary and confirm bleed on test prints.
- Complex source PDF features (optional-content layers, transparencies, overprints, signatures, colour profiles and spot colours) are copied as PDF resources, but are **not automatically preflight-verified**. For production work, proof separations and output from your actual RIP.
- Large or untrusted PDFs may use significant memory; each source page content stream is limited to 256 MiB of decompressed data.
- Password-protected PDFs are not supported.

### Developer commands

```bash
cargo test
cargo run --release
cargo run --release -- --impose job.json printready.pdf
```

Job JSON format:

```json
{
  "files": ["/Users/you/Documents/job.pdf"],
  "config": {
    "mode": "GangUp",
    "paper": "Sra3",
    "landscape": false,
    "custom_width_mm": 320,
    "custom_height_mm": 450,
    "rows": 2,
    "cols": 2,
    "margin_mm": 8,
    "gap_mm": 4,
    "marks": true,
    "mark_length_mm": 3,
    "mark_offset_mm": 1.5,
    "scale": "Fit",
    "auto_rotate": true,
    "back_rotate_180": false,
    "creep_mm": 0
  }
}
```

## Project structure

- `src/layout.rs` — layout planning, booklet signatures, cut/stack and unit tests.
- `src/impose.rs` — vector-safe PDF resource graph importer, placement transforms, trim marks, PDF export and tests.
- `src/main.rs` — native Rust desktop interface, source management, presets, previews and PDF export.
- `mac/preview.swift` — small Apple PDFKit PNG thumbnail helper (rendering only).
- `mac/build_mac.sh`, `BUILD_MAC.command` — builds and packages the Apple Silicon `.app` locally.
- `examples/sample_8pages.pdf` — 8-page sample input for testing booklet imposition.

**Build validation disclaimer:** No successful Apple Silicon runner build, GUI smoke test, or physical print test is available from this environment, so no executable is represented as tested. The included workflow verifies architectures, dependent libraries, tests and signatures and will fail rather than publish the distributable when build checks fail.

### Missing `cargo` fix (v0.1.2)

The v0.1.1 builder stopped when Cargo was missing. v0.1.2 automatically downloads the official rustup installer to the **build Mac**, installs a native Rust toolchain if necessary, then continues. For security, the rustup installation only downloads from `https://sh.rustup.rs` over HTTPS. No developer tools are included with, or needed to run, the final `.app`. The download requires internet access. If you prefer not to install Rust locally, use the GitHub Actions option, which builds the ready-to-install app on a separate Mac. **A macOS build has not been run in this Linux environment; output remains unverified until the Mac job succeeds.**
