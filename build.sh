#!/bin/bash

# Copyright (C) 2026, Arghyadeep Mondal <github.com/arghya339>

readonly good="\033[92;1m[✔]\033[0m"
readonly bad="\033[91;1m[✘]\033[0m"
readonly info="\033[94;1m[i]\033[0m"
readonly running="\033[37;1m[~]\033[0m"
readonly notice="\033[93;1m[!]\033[0m"
readonly question="\033[93;1m[?]\033[0m"

Green="\033[92m"
BoldGreen="\033[92;1m"
Red="\033[91m"
Blue="\033[94m"
Cyan="\033[96m"
White="\033[37m"
whiteBG="\e[47m\e[30m"
Yellow="\033[93m"
Reset="\033[0m"

app=$1
workingDir=$(pwd)
buildDir=$workingDir/build
outDir=$buildDir/out
mkdir -p "$outDir"
pkgs=(aria2 libarchive-tools pv openjdk-21-jdk)
cloudflareDOH="https://cloudflare-dns.com/dns-query"
cloudflareIP="1.1.1.1,1.0.0.1"

pkgInstall() {
  if ! grep -q "^$1" <<< "$pkgList" 2>/dev/null; then
    echo -e "$running Installing $1 package.."
    sudo apt install ${1} -y &>/dev/null
  fi
}

setup() {
  sudo apt update &>/dev/null
  pkgList=$(apt list --installed 2>/dev/null)
  for pkg in "${pkgs[@]}"; do
    pkgInstall $pkg
  done
}

upgCurl() {
  curlVer=$(curl -V | head -1 | awk '{print $2}')
  if [ $(cut -d. -f1 <<< $curlVer) -lt 8 ] || [ $(cut -d. -f2 <<< $curlVer) -lt 19 ]; then
    snap version &>/dev/null || pkgInstall "snapd"
    echo -e "$running Installing curl package.."
    sudo snap install curl &>/dev/null
    export PATH="/snap/bin:$PATH"
    curl.snap-acked >/dev/null
  fi
}

grep -qi "debian" /etc/os-release 2>/dev/null && { setup; upgCurl; }

dl() {
  dlUrl=$1
  assPath=$2
  if [ -n "$assPath" ]; then
    fileName=$(basename "$assPath")
    dirName=$(dirname "$assPath")
  else
    fileName=$(basename "$dlUrl")
    dirName=$workingDir
  fi
  echo -e "$running Downloading ${Red}$fileName${Reset} from ${Blue}$dlUrl${Reset}"
  while true; do
    aria2c -x 16 -s 16 --console-log-level=error --summary-interval=0 --download-result=hide -c -o "$fileName" -d "$dirName" "$dlUrl"
    exStatus=$?; echo
    [ $exStatus -eq 0 ] && break || { echo -e "$notice ${Yellow}Download failed! retrying in 5 seconds.${Reset}"; sleep 5; }
  done
  return 0
}

instPup() {
  if ! pup --version &>/dev/null; then
    dl "https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip" "$workingDir/pup_v0.4.0_linux_amd64.zip"
    pv "$workingDir/pup_v0.4.0_linux_amd64.zip" | sudo bsdtar -xf - -C "/usr/local/bin"
    [ -x "/usr/local/bin/pup" ] || sudo chmod +x /usr/local/bin/pup
    pup --version &>/dev/null && echo -e "$good pup package installed successfully."
    rm -f "$workingDir/pup_v0.4.0_linux_amd64.zip"
  fi
}; instPup

dlGh() {
  repoSlug=$1
  assRgx="${2/\*/.\*}"
  dlPath=${3:-workingDir}
  tag=$(curl -sL -H "Authorization: Bearer $GH_TOKEN" "https://api.github.com/repos/${repoSlug}/releases" | jq -r 'sort_by(.published_at) | reverse | .[0].tag_name')
  ghApiUrl="https://api.github.com/repos/${repoSlug}/releases/tags/${tag}"
  ghResp=$(curl -sL -H "Authorization: Bearer $GH_TOKEN" "$ghApiUrl")
  selAss=$(jq -r --arg assRgx "$assRgx" '.assets[] | select(.name | test($assRgx))' <<< "$ghResp")
  assName=$(jq -r '.name' <<< "$selAss")
  dlUrl=$(jq -r '.browser_download_url' <<< "$selAss")
  filePath="$dlPath/$assName"
  dl $dlUrl $filePath
  return 0
}

appsJson=$(jq . "$workingDir/apps.json")
selApp=$(jq -r --arg app "$app" '.[] | select(.app == $app)' <<< "$appsJson")
mapfile -t abilist < <(jq -r '.abilist[]' <<< "$selApp")
getAss() {
  cliSrc=$(jq -r '.cliSrc' <<< "$selApp")
  cliAssRgx=$(jq -r '.cliAssRgx' <<< "$selApp")
  cliVer=$(jq -r '.cliVer' <<< "$selApp")
  woProt="${cliSrc#*://}"
  cliRepoSlug="${woProt#*/}"
  if [ "$cliVer" != "null" ]; then
    filename="revanced-cli-$cliVer-all.jar"
    dlUrl="$cliSrc/releases/download/v$cliVer/$filename"
    cliPath=$buildDir/$filename
    dl $dlUrl $cliPath
  else
    dlGh $cliRepoSlug $cliAssRgx $buildDir
    cliPath=$filePath
  fi
  ptchSrc=$(jq -r '.ptchSrc' <<< "$selApp")
  ptchAssRgx=$(jq -r '.ptchAssRgx' <<< "$selApp")
  woProt="${ptchSrc#*://}"
  dn="${woProt%%/*}"
  ptchRepoSlug="${woProt#*/}"
  if [ "$ptchRepoSlug" == "ReVanced/revanced-patches" ]; then
    rvApiResp=$(curl -sL "https://api.revanced.app/v5/patches")
    ptchVer=$(jq -r '.version | sub("^v"; "")' <<< "$rvApiResp")
    dlUrl=$(jq -r '.download_url' <<< "$rvApiResp")
    ptchPath="${buildDir}/$(basename "$dlUrl")"
    dl "$dlUrl" "$ptchPath"
  else
    if [ "$dn" == "github.com" ]; then
      dlGh $ptchRepoSlug $ptchAssRgx $buildDir
      ptchPath=$filePath
      [[ "${tag:0:1}" =~ [a-zA-Z] ]] && ptchVer="${tag:1}" || ptchVer="$tag"
    fi
  fi
  intSrc=$(jq -r '.intSrc' <<< "$selApp")
  woProt="${intSrc#*://}"
  intRepoSlug="${woProt#*/}"
  if [ "$intSrc" != "null" ]; then
    intAssRgx="revanced-integrations-*.apk"
    dlGh "$intRepoSlug" "$intAssRgx" $buildDir
    intPath=$filePath
  fi
}

dlApp() {
  pkg=$1
  appVer=$2
  archRef=$3
  APKM_REST_API_URL="https://www.apkmirror.com/wp-json/apkm/v1/app_exists/"
  AUTH_TOKEN="YXBpLXRvb2xib3gtZm9yLWdvb2dsZS1wbGF5OkNiVVcgQVVMZyBNRVJXIHU4M3IgS0s0SCBEbmJL"
  source <(curl -sL "https://raw.githubusercontent.com/arghya339/Simplify/refs/heads/main/Termux/APKMdl.sh")
  Download=$buildDir
  crVersion=$(curl -sL "https://chromiumdash.appspot.com/fetch_releases?channel=Stable&platform=Android&num=1" | jq -r '.[0].version')
  USER_AGENT="Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$crVersion Mobile Safari/537.36"
  #curl -V | head -1 | awk '{print $1" "$2}'
  [ "$pkg" == "com.google.android.apps.photos" ] && bcmIdx=2 || bcmIdx=
  [ "$pkg" == "com.microblink.photomath" ] || type="APK"
  APKMdl "$pkg" "$bcmIdx" ${appVer} "$type" "$archRef"
  appPath="$outputPath"
  appVer="$VERSION"
}

ptchrArgs=()
loadPtch() {
  ptchTxt="$workingDir/apps/${app}/patches.txt"
  if [ -s "$ptchTxt" ]; then
    mapfile -t lines < "$ptchTxt"
    for line in "${lines[@]}"; do
      [ -z "$line" ] && continue
      eval ptchrArgs+=("$line")
    done
  fi
}

getBra() {
  if [ "$ptchRepoSlug" == "MorpheApp/morphe-patches" ]; then
    bra="morphe_branding"
  elif [ "$ptchRepoSlug" == "ReVanced/revanced-patches" ]; then
    bra="revanced_branding"
  else
    bra="branding"
  fi
  if [ ! -d "$workingDir/$bra" ]; then
    dl "https://github.com/arghya339/Simplify/releases/download/all/$bra.zip" "$workingDir/$bra.zip"
    echo -e "$running Extrcting ${Red}$bra.zip${Reset} to $workingDir dir.."
    pv "$workingDir/$bra.zip" | bsdtar -xof - -C "$workingDir/" --no-same-owner --no-same-permissions
    rm -f $workingDir/$bra.zip
  fi
}

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
java --version | head -1 | awk '{print $1" "$2}'

dlBcp() {
  bcpVer=$(curl -sL "https://repo1.maven.org/maven2/org/bouncycastle/bcprov-jdk18on/maven-metadata.xml" | awk -F'[<>]' '/<latest>/{print $3}')
  filename="bcprov-jdk18on-${bcpVer}.jar"
  bcpJarPath="$buildDir/$filename"
  dlUrl="https://repo1.maven.org/maven2/org/bouncycastle/bcprov-jdk18on/$bcpVer/$filename"
  [ -f $bcpJarPath ] || dl "$dlUrl" "$bcpJarPath"
}

genBcpKey() {
  dlBcp
  ksPath="$buildDir/ks.keystore"
  [ -f $ksPath ] || keytool -genkey -v -keystore "$ksPath" -storetype BKS -providerclass org.bouncycastle.jce.provider.BouncyCastleProvider -providerpath "$bcpJarPath" -alias "Morphe" -keyalg RSA -sigalg SHA256withRSA -keysize 4096 -validity 70080 -dname "CN=Morphe" -storepass "Morphe" -keypass "Morphe"
}

sign() {
  genBcpKey
  apksignerJarPath="/usr/share/java/apksigner.jar"
  [ -f "/usr/bin/apksigner" ] || pkgInstall "apksigner"
  java -cp "$apksignerJarPath:$bcpJarPath" com.android.apksigner.ApkSignerTool sign --ks "$ksPath" --ks-type BKS --ks-provider-class org.bouncycastle.jce.provider.BouncyCastleProvider --ks-key-alias "Morphe" --ks-pass pass:"Morphe" --key-pass pass:"Morphe" --in "$unsignedAppPath" --out "$signedAppPath" --v4-signing-enabled false
}

mkCs() {
  outCsPath="$outDir/${ass}_v${appVer}_v${ptchVer}_gf_cs.apk"
  #pkgInstall "python"
  pip list 2>/dev/null | grep -q "apksigcopier" || { echo -e "$running Installing apksigcopier using pip..."; pip install apksigcopier &>/dev/null; }
  echo -e "$running Creating cs apk by cp sig from $appPath"
  apksigcopier --version &>/dev/null && apksigcopier copy "$appPath" "$outAppPath" "$outCsPath"
}

ass="${app// /-}"
ptchApp() {
  aapt2Path=$(ls -td /usr/local/lib/android/sdk/build-tools/*/aapt2 | head -1)
  if [ "$ptchRepoSlug" != "d4n3436/revanced-patches-android5" ]; then
    ([ "$pkg" == "com.google.android.youtube" ] || [ "$pkg" == "com.google.android.apps.youtube.music" ]) && getBra
  fi
  tag="${ass}_v${ptchVer}"
  name="${app} v${appVer} (${ptchVer})"
  [ "$app" == "YT Morphe" ] && mkLatest=true || mkLatest=false
  [ "$cliRepoSlug" != "MorpheApp/morphe-desktop" ] && mkPre=true || mkPre=false
  {
    echo "TAG=$tag"
    echo "NAME=$name"
    echo "OUT_DIR=$outDir"
    echo "MK_LATEST=$mkLatest"
    echo "MK_PRE=$mkPre"
  } >> "$GITHUB_ENV"
  tempPath="$buildDir/$(date +"%Y%m%d%H%M%S")"
  mkdir -p "$tempPath"
  ([ "$pkg" == "com.google.android.youtube" ] || [ "$pkg" == "com.google.android.apps.youtube.music" ]) && outAppPath="$outDir/${ass}_v${appVer}_v${ptchVer}_gf_${abi}.apk" || outAppPath="$outDir/${ass}_v${appVer}_v${ptchVer}_${abi}.apk"
  if [ $foundGmsPtch == true ] && [ $modPtchrArgs == true ]; then
    ([ "$pkg" == "com.google.android.youtube" ] || [ "$pkg" == "com.google.android.apps.youtube.music" ]) && outAppPath="$buildDir/${ass}_v${appVer}_v${ptchVer}_gf_${abi}.apk" || outAppPath="$buildDir/${ass}_v${appVer}_v${ptchVer}_${abi}.apk"
  fi
  ([ "$pkg" == "com.google.android.youtube" ] || [ "$pkg" == "com.google.android.apps.youtube.music" ]) && modName="${ass}_v${appVer}_v${ptchVer}_gf_${abi}.zip" || modName="${ass}_v${appVer}_v${ptchVer}_${abi}.zip"
  outModPath="$outDir/$modName"
  echo -e "$running Patching ${appName}_v${appVer}-${abi}..."
  if [ "$cliVer" == "3.1.4" ]; then
    java -jar $cliPath patch "$appPath" -o $outAppPath -m $intPath --options "$workingDir/apps/${app}/options.json" -b $ptchPath "${ptchrArgs[@]}" -t=$tempPath | tee $outDir/ptchLog.txt
  else
    if [ "$cliRepoSlug" == "inotia00/revanced-cli" ]; then
      java -jar $cliPath patch -p $ptchPath -o $outAppPath "$appPath" "${ptchrArgs[@]}" -t=$tempPath -f | tee $outDir/ptchLog.txt
    elif [ "$cliRepoSlug" == "ReVanced/revanced-cli" ]; then
      java -jar $cliPath patch -p $ptchPath -b -o $outAppPath "$appPath" "${ptchrArgs[@]}" -t=$tempPath -f | tee $outDir/ptchLog.txt
    else
      java -jar $cliPath patch -p $ptchPath -o $outAppPath "$appPath" "${ptchrArgs[@]}" --bytecode-mode=FULL -t=$tempPath --disable-purge -f | tee $outDir/ptchLog.txt
    fi
  fi
  rm -f $outDir/*.keystore $outDir/*.idsig
  #[ -f "$outAppPath" ] || rm -rf $outDir/*temp*
}

delPrevTag() {
  prevTag=$(curl -sL -H "Authorization: Bearer $GH_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/releases" | jq -r --arg tag "${ass}_v" '.[].tag_name | select(startswith($tag))' | tail -1)
  if [ -n "$prevTag" ]; then
    if [ "$prevTag" != "$tag" ]; then
      prevRelId=$(curl -sL -H "Authorization: Bearer $GH_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/releases/tags/$prevTag" | jq -r '.id')
      curl -sLX DELETE -H "Authorization: Bearer $GH_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/releases/$prevRelId" && echo -e "$good Previous release deleted."
      curl -sLX DELETE -H "Authorization: Bearer $GH_TOKEN" "https://api.github.com/repos/$GITHUB_REPOSITORY/git/refs/tags/$prevTag" && echo -e "$good Previous tag deleted."
    fi
  fi
}

getAppVer() {
  if [ "$cliRepoSlug" == "MorpheApp/morphe-desktop" ]; then
    appVer=$(java -jar $cliPath list-versions --patches=$ptchPath -f=$pkg -x=true | sed 's/^[[:space:]]*//; s/ (.*//;' | grep -E '^[0-9]|^Any$' | sort -rV | head -n 2 | head -1)
  elif [ "$cliRepoSlug" == "ReVanced/revanced-cli" ]; then
    appVer=$(java -jar $cliPath list-versions -p=$ptchPath -b -f=$pkg | sed 's/^[[:space:]]*//; s/ (.*//;' | grep -E '^[0-9]|^Any$' | sort -rV | head -n 2 | head -1)
  fi
}

replTxt() {
  echo -e "$running Replacing $old text with $new in $tgtFile"
  sed -i "s/${old//./\\.}/${new}/g" "$tgtFile"
}

git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
urlEncApp=$(sed 's/ /%20/g' <<< "$app")
mkMod() {
  echo -e "$running Creating ${appName}_v${appVer}-${abi} module..."
  [ ! -d $workingDir/revanced-magisk-module ] && git clone --depth 1 https://github.com/j-hc/revanced-magisk-module
  modNameWoExt="${modName%.*}"
  modPath="$buildDir/$modNameWoExt"
  cp -r $workingDir/revanced-magisk-module/module $modPath
  mkdir -p $modPath/stock
  cp "$appPath" $modPath/stock/base.apk
  cp $outAppPath $modPath/base.apk
  case "$abi" in
    "arm64-v8a") modArch="arm64" ;;
    "armeabi-v7a") modArch="arm" ;;
    "x86_64") modArch="x64" ;;
    "x86") modArch="x86" ;;
    "universal") modArch="" ;;
    *) modArch="$abi" ;;
  esac
  cat << EOF > $modPath/config
PKG_NAME=${pkg}
PKG_VER=${appVer}
MODULE_ARCH=${modArch}
EOF
  old="rvhc"; new="rvapp"
  tgtFile="$modPath/utils.sh"; replTxt
  tgtFile="$modPath/customize.sh"; replTxt
  modId=$(tr '[:upper:]' '[:lower:]' <<< "$ass")
  modVer="v${appVer} (${ptchVer})"
  modVCode=$(date +"%Y%m%d%H")
  modUpJson="https://raw.githubusercontent.com/${GITHUB_REPOSITORY}/refs/heads/main/apps/${urlEncApp}/update-${abi}.json"
  cat << EOF > $modPath/module.prop
id=${modId}
name=${app}
version=v${appVer} (${ptchVer})
versionCode=${modVCode}
author=j-hc & arghya339
description=${app} Module
updateJson=${modUpJson}
EOF
  tgtFile="$modPath/uninstall.sh"; replTxt
  (cd "$modPath" && bsdtar --format=zip -c -f - *) | pv -t -b -r > "$outModPath"
  zipUrl="https://github.com/${GITHUB_REPOSITORY}/releases/download/${tag}/${modName}"
  chgLogUrl=null
  upJson="$workingDir/apps/${app}/update-${abi}.json"
  jq -n --arg version "$modVer" --argjson versionCode "$modVCode" --arg zipUrl "$zipUrl" --arg changelog "$chgLogUrl" '{version: $version, versionCode: $versionCode, zipUrl: $zipUrl, changelog: $changelog}' > "$upJson"
  git add "$upJson"
}

mkBody() {
  if [ "$cliRepoSlug" == "MorpheApp/morphe-desktop" ] || [ "$cliRepoSlug" == "ReVanced/revanced-cli" ]; then
    [ -f $workingDir/body.md ] || cp "$workingDir/apps/${app}/notes.md" $workingDir/body.md
    #cfgUrl="https://github.com/$GITHUB_REPOSITORY/blob/main/apps%2F$urlEncApp%2Fsettings.txt"
    #rawCfgUrl="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/refs/heads/main/apps/$urlEncApp/settings.txt"
    olds=("appVer" "ptchVer" "repoOwner%2FrepoName" "author%22%3A%22repoOwner"); news=("$appVer" "$ptchVer" "${GITHUB_REPOSITORY_OWNER}%2F${GITHUB_REPOSITORY#*/}" "author%22%3A%22${GITHUB_REPOSITORY_OWNER}")
    for ((i=0; i<${#olds[@]}; i++)); do
      old="${olds[i]}"; new="${news[i]}"; tgtFile="$workingDir/body.md"; replTxt
    done
  else
    cp "$workingDir/apps/${app}/notes.md" $workingDir/body.md
    echo -e "$notice Replacement text in $workingDir/body.md skipped!"
  fi
}

buildApp() {
  getAss
  pkg=$(jq -r '.pkg' <<< "$selApp")
  appVer=$(jq -r '.appVer' <<< "$selApp")
  mkMod=$(jq -r '.mkMod' <<< "$selApp")
  [ "$appVer" == "null" ] && getAppVer
  loadPtch
  foundGmsPtch=false; modPtchrArgs=false
  if grep -q "GmsCore" <<< "${ptchrArgs[@]}"; then
    foundGmsPtch=true
    [ "$cliVer" == "null" ] && { inc="-e"; ex="-d"; } || { inc="-i"; ex="-e"; }
    for ((i=0; i<${#ptchrArgs[@]}; i++)); do
      grep -q "GmsCore" <<< "${ptchrArgs[i]}" && { gmsIdx=$i; gmsPtch="${ptchrArgs[i]}"; break; }
    done
  fi
  for abi in "${abilist[@]}"; do
    if [ $foundGmsPtch == true ]; then
      modPtchrArgs=false
      ptchrArgs[gmsIdx-1]="$inc"
    fi
    dlApp "$pkg" ${appVer} "${abi}"
    ptchApp
    if [ $foundGmsPtch == true ] && [ $mkMod == true ]; then
      ptchrArgs[gmsIdx-1]="$ex"
      modPtchrArgs=true
      ptchApp
    fi
    [ $mkMod == true ] && mkMod
  done
  mkBody
  if [ $mkMod == true ]; then
    [ "$(git --no-pager log -1 --pretty=%s)" == "Update App" ] && git reset --soft HEAD~1
    git diff --cached --quiet || git commit -m "Update App"
    git push -f
  fi
  delPrevTag
}; buildApp
ls $outDir
###################################################