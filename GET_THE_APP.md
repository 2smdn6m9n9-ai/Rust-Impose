# Obtain the complete Rust Impose.app — no dependencies on the Mac where you install it

**Important:** This folder contains the application SOURCE and a build workflow, not a compiled Apple Silicon .app. The builder runs on a real Apple Silicon macOS machine and produces the deliverable files. The current source has **not** been verified by a completed Apple Silicon build.

## Recommended: automatic macOS build on GitHub (no Rust/Xcode needed on your Mac)

1. Create a new repository on GitHub and put the contents of this folder at the repository root, **including `.github/workflows/build-apple-silicon.yml`**. Commit these files. You can use the GitHub web interface or GitHub Desktop. The workflow starts on push to `main` or `master`.
2. Open the repository's **Actions** tab and choose **Build portable Rust Impose for Apple Silicon**. If it has not already run, select **Run workflow**.
3. When the workflow succeeds, open its run and download the artifact **RustImpose-AppleSilicon-ReadyToInstall**. Unzip that artifact. It contains `RustImpose-AppleSilicon.dmg` and `RustImpose-AppleSilicon.zip`.
4. Open the `.dmg` and drag **Rust Impose.app** onto **Applications**. Eject the image. That's the final installation; **Rust and Xcode are not required on your Mac**.

The workflow uses GitHub's Apple Silicon `macos-15` hosted runner to compile both included executables and package them. This may consume GitHub Actions minutes; costs and quotas depend on repository visibility and account plan.

## Alternative: build on any Apple Silicon Mac

Extract the new v0.1.2 package on an Apple Silicon **BUILD** Mac and double-click `BUILD_MAC.command`. This detects whether `cargo` is installed and, when necessary, automatically installs Rust (including Cargo) using the official rustup installer. If Apple's Command Line Tools are missing, it opens Apple's installation dialog. After you approve the Apple tools installation, run `BUILD_MAC.command` again. This requires internet access on the build Mac; **no developer tools are needed on the Mac receiving the finished `.app`**. The result is `dist/RustImpose-AppleSilicon.dmg` and `dist/RustImpose-AppleSilicon.zip`. Transfer either finished file to other Apple Silicon Macs. **Those other Macs need no extra dependencies.**

## What's included inside the app

- Native arm64 `RustImpose` executable (Rust UI plus PDF imposition engine)
- Native arm64 `impose_preview` executable for macOS PDFKit page previews
- App icon, bundle metadata, and code signature
- No Python environment, Node, Java, Docker, server, system-wide Rust toolchain, or external renderer
- PDFKit, AppKit, Metal and other Apple system frameworks provided by macOS 13 or later

**Code signing:** Without an Apple Developer ID and notarisation, the output is locally/ad-hoc signed; macOS Gatekeeper may block the first launch of a downloaded app. Go to **System Settings → Privacy & Security → Open Anyway** if you trust the build, or control-click the app and choose **Open** if offered. To distribute with normal first-launch behaviour, a Developer ID signature and Apple notarisation are required.

**Scope:** This is the initial imposition tool, not Fiery Command WorkStation or a finished replacement for Fiery Impose's full finishing and preflight functionality. Proof all print jobs.

## If an old package says `ERROR: Missing cargo`

**Use the updated `RustImposeMac_AppleSilicon_AutoBuild_v0.1.2.zip` package.** Extract it into a fresh folder (do not run the old `BUILD_MAC.command`). The new script installs the missing Rust toolchain automatically on the build Mac and resumes. It will not try to install developer tools on other Macs where you only run the finished application.

Alternatively, to repair the original build folder manually, open Terminal on the build Mac and run:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
cargo --version
```

Then rerun `BUILD_MAC.command` from the original folder. Apple Command Line Tools are a separate macOS component. If needed, run `xcode-select --install`, approve Apple's dialog, then rerun the build command. Both installations are only needed on the **build** Mac.
