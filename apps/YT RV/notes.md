<details><summary>

#### 🔍App varient
</summary>

▶️[YT-RV_vappVer_vptchVer_gf_universal.apk](../../releases/download/YT-RV_vptchVer/YT-RV_vappVer_vptchVer_gf_universal.apk)
📦[YT-RV_vappVer_vptchVer_gf_universal.zip](../../releases/download/YT-RV_vptchVer/YT-RV_vappVer_vptchVer_gf_universal.zip)
</details>

<details><summary>

#### ℹ️APP Info
</summary>

- Version: appVer (ptchVer)
- Package: app.revanced.android.youtube
- Min: Android 8.0+
- Architecture: arm64-v8a + armeabi-v7a + x86 + x86_64 (universal)
- keystore: revanced.keystore (if you get `conflicts` error during installation, uninstall exiting one and install new one)
</details>

<details><summary>

#### 🧩Plugins
</summary>

Install 🧩[ReVanced GmsCore](https://github.com/ReVanced/GmsCore/releases/) for non-root YouTube and YT Music
Install 🦭[Seal](https://github.com/JunkFood02/Seal/releases) for Download all Videos/Music in the YouTube with one click, based on [yt-dlp](https://github.com/yt-dlp/yt-dlp).
</details>

#### ❓[Changelog](https://github.com/ReVanced/revanced-patches/releases/tag/vptchVer)

<details><summary>

#### 🎭ROOT Method
</summary>

📦[YT-RV_vappVer_vptchVer_gf_universal.zip](../../releases/download/YT-RV_vptchVer/YT-RV_vappVer_vptchVer_gf_universal.zip): flash from [Magisk](https://github.com/topjohnwu/Magisk/releases)/[KernelSU](https://github.com/tiann/KernelSU)/[APatch](https://github.com/bmax121/APatch)/[MMRL](https://github.com/DerGoogler/MMRL/releases).

Use 🚫[UpdateLocker](https://github.com/Xposed-Modules-Repo/ru.mike.updatelocker) [Vector](https://github.com/JingMatrix/Vector/releases)/[Xposed](https://github.com/ElderDrivers/EdXposed) module to block auto-update YouTube via Play Store if you are using -module.zip/-cs.apk
*[ReVanced Manager](https://github.com/ReVanced/revanced-manager/releases): arm64-v8a + armeabi-v7a only
*[Simplify](https://github.com/arghya339/Simplify): universal
*[revanced-magisk-module](https://github.com/j-hc/revanced-magisk-module/releases): arm64-v8a + armeabi-v7a
</details>

<details><summary>

#### 📥Installation Guide
</summary>

#### 🪐Universal Guide
1. Install [DevCheck](https://play.google.com/store/apps/details?id=flar2.devcheck)
2. Open `DevCheck` > `System` > `Android Version` & `Architecture` (Note: Your Android Version & Architecture)
ex¹ if Your Device `Architecture aarch64` then download `arm64-v8a.apk`
ex² if Your Device 'Architecture aarch32' then download `armebai-v7a.apk`
ex³ if Your Device 'Architecture x86_64' then download `x86_64.apk`
ex⁴ if Your Device 'Architecture x86' then download `x86.apk`

<details><summary>

#### 📲Device Specific Guide
</summary>

#### Arch Specific only (Optional)
1. Install [Obtainium](https://github.com/ImranR98/Obtainium/releases)
2. click on `Obtainium Import`
3. Open `Obtainium` > `Apps` > install `microG` + `YouTube RV` & `Seal`(optional)
> [!NOTE]
> If the fetch fails due to authentication, you may need to authenticate to GitHub Projects.
> Create a PAT with the scope `read:project` & Expiration `No expiration` [here](https://github.com/settings/tokens/new?scopes=read:project&description=Obtainium) and add your token to `Obtainium` > `Settings` > `GitHub Personal Access Token (lncreases Rate Limit)`.

#### Android 11+ only (Optional)
4.a. Install & Open  [Shizuku](https://play.google.com/store/apps/details?id=moe.shizuku.privileged.api) > Start via Wireless debugging > pairing > Notification options > turn on All Shizuku notifications
4.b. turn on hotspot on your friends phone > Connect your phone to your friends wifi-hotsot
4.c. open Settings > About phone > tap 7time Build number > back to your device main Settings > System > Developer options > turn on USB debugging > OK > turn on Wireless debugging > Allow > tap on Wireless debugging > Pair device with pairing code > note 1time WiFi pairing code > pull down notification > find Shizuku noti title > Enter pairing code > type your 1time WiFi pairing code > click Send button > Go back to Shizuku > Start via Wireless debugging > Start > wait 3 sec > disconnect wifi-hotspot
4.d. Open Obtainium > Settings > turn on Use Shizuku or Sui to install > Apps > install 'microG' > Allow Obtainium to access Shizuku? > Allow all the time.
*Note: after rebooting device everytime you must need repeat Guide 4.b.&4.c.
</details>
</details>

<details><summary>

#### ⛏️[Obtainium](https://github.com/ImranR98/Obtainium/releases) Import
</summary>

[ReVanced GmsCore](https://apps.obtainium.imranr.dev/redirect?r=obtainium://app/%7B%22id%22%3A%22app.revanced.android.gms%22%2C%22url%22%3A%22https%3A%2F%2Fgithub.com%2FReVanced%2FGmsCore%22%2C%22author%22%3A%22ReVanced%22%2C%22name%22%3A%22GmsCore%22%2C%22additionalSettings%22%3A%22%7B%5C%22apkFilterRegEx%5C%22%3A%5C%22app.revanced.android.gms-.*%5B0-9%5D-signed.apk%5C%22%7D%22%7D)

[YT RV](https://apps.obtainium.imranr.dev/redirect?r=obtainium://app/%7B%22id%22%3A%22app.revanced.android.youtube%22%2C%22url%22%3A%22https%3A%2F%2Fgithub.com%2FrepoOwner%2FrepoName%22%2C%22author%22%3A%22repoOwner%22%2C%22name%22%3A%22YT%20RV%22%2C%22additionalSettings%22%3A%22%7B%5C%22filterReleaseTitlesByRegEx%5C%22%3A%5C%22YT%20RV%20v%5C%22%2C%5C%22apkFilterRegEx%5C%22%3A%5C%22_gf_universal.apk%5C%22%7D%22%7D)

[Seal](https://apps.obtainium.imranr.dev/redirect?r=obtainium://app/%7B%22id%22%3A%22com.junkfood.seal%22%2C%22url%22%3A%22https%3A%2F%2Fgithub.com%2FJunkFood02%2FSeal%22%2C%22author%22%3A%22JunkFood02%22%2C%22name%22%3A%22Seal%22%7D)
</details>

<details><summary>

#### ⚙️Configuration Guide
</summary>

Download [settings.txt](../../blob/main/apps/YT%20RV/settings.txt) then Open `YouTube RV` > tap on `Avatar` menu > `Settings` > `ReVanced` > `Miscellaneous` > `Import/Export settings` > choose `Import settings from file` & select downloaded `settings.txt` > `RESTART`.
</details>

<details><summary>

#### ⏳[Restore old UI layout](https://support.google.com/youtube/thread/185510529/youtube-has-a-refreshed-look-feel?hl=en)
</summary>

Open `YouTube RV` > tap on `Avatar` menu > `Settings` > `ReVanced` > `Miscellaneous` > turn on `Spoof app version` & click `Spoof app version target` & select `17.08.35` > `RESTART`.
</details>

<details><summary>

#### 🚩Related Repo
</summary>

🌐[YTPro](https://github.com/prateek-chaubey/YTPro/releases): Webview based YouTube with ads blocker
📺[SmartTube](https://github.com/yuliskov/SmartTube/releases): Ads free YouTube for Android TV Boxes
[apk-me](https://github.com/arghya339/apk-me/releases/): Some Popular Android App
</details>

<details><summary>

#### 🫡Credits
</summary>

Thanks to:
- [microG](https://github.com/microg)
- [TeamVanced](https://github.com/TeamVanced)
- [ReVanced](https://github.com/ReVanced)
- [inotia00](https://github.com/inotia00)
- [j-hc](https://github.com/j-hc)
- [JunkFood02](https://github.com/JunkFood02)
- [ImranR98](https://github.com/ImranR98)
- [RikkaApps](https://github.com/RikkaApps)
- [topjohnwu](https://github.com/topjohnwu)
- [JingMatrix](https://github.com/JingMatrix)
- [Apktool](https://github.com/iBotPeaches/Apktool)
- [Maximoff](https://github.com/Maximoff)
by [arghya339](https://github.com/arghya339)
</details>

<details><summary>

#### 💌Support
</summary>

💲Donation: [PayPal/@arghyadeep339](https://www.paypal.com/paypalme/arghyadeep339)
Subscribe: [YouTube/@MrPalash360](https://www.youtube.com/channel/UC_OnjACMLvOR9SXjDdp2Pgg/videos?sub_confirmation=1)
Follow: Telegram WhatsApp
Join: Telegram WhatsApp
</details>