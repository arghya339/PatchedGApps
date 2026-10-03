<div align="center">

<img src="https://raw.githubusercontent.com/lobehub/lobe-icons/refs/heads/master/packages/static-png/light/google-color.png" width="100">

# PatchedGApps
**An automated cloud-patched Google Apps builder powered by GitHub Actions.**

![Bash Script](https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white) ⚡ ![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)
</div>

## ✨ Key Features
* **☁️ Cloud-Based Execution:** Runs all build scripts, patching logic inside GitHub Actions runners.
* **🤖 Automated Releases:** The workflow generates both **standalone patched APK** and **flashable Magisk/KSU/APatch modules** with OTA update support.

## 📥 Download

> [!TIP]
> You may need to open README.md in a browser to find the download-able Patched GApps releases.

![YouTube](https://img.shields.io/badge/YouTube-%23FF0000.svg?style=for-the-badge&logo=YouTube&logoColor=white)
YouTube|Android|Link|Features|SrcCode
:--|:--|:--|:--|:--
Morphe|10~17|[[⤓]](../../releases?q=YT+Morphe&expanded=false)|Hide ads|[</>](https://github.com/MorpheApp/morphe-patches)
Morphe A9|9|[[⤓]](../../releases?q=YT+Morphe+A9&expanded=false)|Hide ads|[</>](https://github.com/MorpheApp/morphe-patches)
RVX|9~17|[[⤓]](../../releases?q=YT+RVX&expanded=false)|Hide ads|[</>](https://github.com/anddea/revanced-patches)
RVX A8|8|[[⤓]](../../releases?q=YT+RVX+A8&expanded=false)|Hide ads|[</>](https://github.com/anddea/revanced-patches)
RV|8~17|[[⤓]](../../releases?q=YT+RV+prerelease%3Atrue&expanded=false)|Hide ads|[</>](https://gitlab.com/ReVanced/revanced-patches)
RVX A6-7|6~7|[[⤓]](../../releases?q=YT+RVX+A6-7&expanded=false)|Hide ads|[</>](https://github.com/kitadai31/revanced-patches-android6-7)
RVX A5|5|[[⤓]](../../releases?q=YT+RVX+A5+v16.40.36&expanded=false)|Hide ads|[</>](https://github.com/d4n3436/revanced-patches-android5)

![YouTube Music](https://img.shields.io/badge/YouTube_Music-%23FF0000.svg?style=for-the-badge&logo=youtube-music&logoColor=white)
YT Music|Android|Link|Features|SrcCode
:--|:--|:--|:--|:--
Morphe|8~17|[[⤓]](../../releases?q=YT+Music+Morphe&expanded=false)|Hide ads|[</>](https://github.com/MorpheApp/morphe-patches)
RVX|8~17|[[⤓]](../../releases?q=YT+Music+RVX&expanded=false)|Hide ads|[</>](https://github.com/anddea/revanced-patches)
RV|8~17|[[⤓]](../../releases?q=YT+Music+RV&expanded=false)|Hide ads|[</>](https://gitlab.com/ReVanced/revanced-patches)
RVX A7|7|[[⤓]](../../releases?q=YT+Music+RVX+A7&expanded=false)|Hide ads|[</>](https://github.com/inotia00/revanced-patches)
RVX A5-6|5~6|[[⤓]](../../releases?q=YT+Music+RVX+A5-6&expanded=false)|Hide ads|[</>](https://github.com/inotia00/revanced-patches)

## 🤝 Contributing
> Issues and feature requests are welcome! Feel free to check the [page](https://github.com/arghya339/ask-me).

## 🛠️ How to Trigger a Build
1. [Create fork](../../fork) of this repo.
2. Go to the **[Actions](../../actions)** tab in forked repository.
3. Select the **Patch** workflow on the left sidebar.
4. Click **Run workflow**.
5. Select your desired app variant from the **`apps`** drop-down menu and run.

## 📁 Repository Structure
```txt
PatchedGApps/
├── .github/
│   └── workflows/
│       └── build.yml     # GitHub Actions workflow to trigger build script in cloud runner
├── build.sh              # Primary build (patching) automation script
├── apps.json             # App configurations (repo sources, and target ABIs, ..)
└── apps/
    └── <AppName>/        # Per-app patch parameters, options, and OTA JSONs
        ├── patches.txt   # Custom patch inclusions/exclusions
        ├── options.json  # Patch option
        ├── update-*.json # Magisk module update definitions
        ├── notes.md      # Releases body template for GitHub Releases
        └── settings.txt  # Apps settings
```

## 👤 Author
![Arghyadeep Mondal](https://avatars.githubusercontent.com/arghya339?s=14) [**Arghyadeep Mondal**](https://github.com/arghya339)

## 💖 Support
This project is open-source and free. If you enjoy using it, consider buying me a coffee!

[![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.paypal.com/paypalme/arghyadeep339)

## 🫡 Credits
- [ReVanced](https://github.com/ReVanced) - ReVanced CLI, Patches, and Integrations
- [inotia00](https://github.com/inotia00) - ReVanced Extended (RVX)
- [Morphe](https://github.com/MorpheApp) - Morphe CLI and Patches
- [j-hc](https://github.com/j-hc) - ReVanced Magisk Module base setup
