# Upload Rust Impose to GitHub (no coding required)

1. At https://github.com/new create a public repository named `RustImpose`. Do NOT initialize with a README, .gitignore or licence.
2. Extract `RustImpose_GitHub_Ready.zip`. Open the extracted folder. On macOS press Command+Shift+. to reveal the hidden `.github` folder.
3. In your GitHub repository, choose **uploading an existing file** (or **Add file > Upload files**). Drag the **contents of the extracted folder** into GitHub, not the ZIP and not the enclosing folder. This includes `.github`, `src`, `mac`, `examples`, `Cargo.toml` and the other files.
4. Confirm the repository contains `.github/workflows/build-apple-silicon.yml` and `Cargo.toml` at its top level, then choose **Commit changes** to `main`.
5. Click **Actions > Build portable Rust Impose for Apple Silicon**. It should start automatically after the upload. Otherwise select **Run workflow > Run workflow**.
6. If the build finishes with a green check, open its run, download the `RustImpose-AppleSilicon-ReadyToInstall` artifact, unzip it and open the resulting `RustImpose-AppleSilicon.dmg`. Drag **Rust Impose.app** into Applications.

IMPORTANT: This ZIP contains build source, NOT a runnable Mac application. The finished DMG only exists after GitHub successfully compiles the project. The source has not yet been confirmed with a successful Apple Silicon compile. If the GitHub run is red, share the failed step and last error lines for repair.

GitHub documentation: https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository
