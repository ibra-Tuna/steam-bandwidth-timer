# 🎮 Steam Bandwidth Timer

A Windows batch script that temporarily throttles Steam download speeds for a set duration, then automatically restores full speed. Ideal for gaming or working without Steam hogging bandwidth.

## ✨ Features

- ⏱️ Set any duration (in minutes) for the throttle to stay active
- 🚦 Choose your own speed limit (in KB/s)
- 🔁 Auto-restores Steam to unlimited speed when time is up
- ✅ Input validation — rejects non-numeric entries
- 🔍 Steam auto-detection — confirms Steam is running and locates `Steam.exe` via the registry
- 🧮 Correct unit conversion — converts KB/s to the Kbit/s format Steam actually expects

## 🚀 Usage

1. Download `steam-bandwidth-timer.bat` (or clone this repo).
2. Make sure Steam is running.
3. Double-click the `.bat` file.
4. When prompted:
   - Enter the **duration in minutes** (e.g., `30`)
   - Enter the **speed limit in KB/s** (e.g., `5000` for ~5 MB/s)
5. Leave the window open. When the countdown finishes, Steam returns to full speed automatically.

> 💡 **Tip:** If Steam is installed in a non-default location and auto-detection fails, edit the script and set the `steam_exe` variable manually.

## ⚠️ Important Notes

### Steam Must Already Be Running

The script uses the `+` launch parameter (`Steam.exe +set_download_throttle <kbps>`) to pass commands to the running Steam client. It will not work if Steam is closed.

### Unit Conversion (KB/s → Kbit/s)

Steam's `set_download_throttle` command expects **Kbit/s**, not KB/s. This script does the conversion for you:

| You enter (KB/s) | Actual limit | Sent to Steam (Kbit/s) |
|------------------|--------------|------------------------|
| `5000`           | ~5 MB/s      | `40000`                |
| `1000`           | ~1 MB/s      | `8000`                 |
| `500`            | ~500 KB/s    | `4000`                 |

### Restoring Manually

If anything goes wrong, open the Steam console (`steam://open/console`) and type:

```
set_download_throttle 0
```

## 🔧 How It Works

1. Verifies Steam is running via `tasklist`
2. Validates your duration and speed inputs
3. Locates `Steam.exe` using the Windows registry
4. Applies the throttle: `Steam.exe +set_download_throttle <kbps>`
5. Waits the specified duration
6. Resets the throttle to `0` (unlimited)

## 📋 Requirements

- Windows 10 / 11
- Steam client installed and running
- Administrator rights not required

## 🐞 Known Limitations

- Does not work while Steam is closed
- Speed limits are approximate
- If you close the window mid-countdown, the throttle stays active until you reset it manually

## 📜 License

MIT — free to use, modify, and share.

## 🤝 Contributing

Pull requests and suggestions are welcome! Feel free to open an issue.
