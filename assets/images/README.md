Place your logo image here as `logo.png`.

Recommended: square PNG (512x512 or 256x256), transparent background.

Quick way to create a tiny placeholder (1x1 transparent PNG) using PowerShell:

Open PowerShell at the project root and run:

```powershell
$base64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQImWNgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII="
[System.IO.File]::WriteAllBytes("assets/images/logo.png", [System.Convert]::FromBase64String($base64))
```

Or using Linux/macOS terminal:

```bash
mkdir -p assets/images
echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQImWNgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=" | base64 --decode > assets/images/logo.png
```

After placing `assets/images/logo.png`, run:

```bash
flutter pub get
flutter run
```

The welcome screen already references `assets/images/logo.png` and will show a fallback placeholder if the file is missing.
