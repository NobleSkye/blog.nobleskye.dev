#!/usr/bin/env bash
# Minecraft Dungeons II - Steam Deck / Linux setup
#
#   curl -fsSL https://blog.nobleskye.dev/scripts/mcd2-steamdeck.sh | bash
#
# Default: installs GDK-Proton and swaps in a working XCurl.dll (original backed up).
# Then in Steam: Properties > Compatibility > GE-Proton11-7-x86_64, restart Steam.
#
# Options (pass after `bash -s --`):
#   --alextibtab   use github.com/Alextibtab/Dungeons2_linux_fix instead
#                  (needs a Microsoft sign-in + a launch option, see the end of the output)
#   --dry-run      only print what would be done
#
#   curl -fsSL https://blog.nobleskye.dev/scripts/mcd2-steamdeck.sh | bash -s -- --dry-run

set -euo pipefail

APPID=1912410
PROTON_URL="https://github.com/LukasPAH/GDK-Proton-Custom/releases/download/release-11-7/GDK-Proton11-7-x86_64.tar.gz"
PROTON_DIR="GDK-Proton11-7"
PROTON_STEAM_NAME="GE-Proton11-7-x86_64"
# Microsoft GDK PC 230307 - the XCurl.dll Alextibtab's fix is built against
XCURL_NUPKG="https://api.nuget.org/v3-flatcontainer/microsoft.gdk.pc.230307/10.0.22621.3139/microsoft.gdk.pc.230307.10.0.22621.3139.nupkg"
XCURL_IN_NUPKG="native/230307/GRDK/ExtensionLibraries/xbox.xcurl.api/redist/commonconfiguration/neutral/XCurl.dll"
FIX_TARBALL="https://github.com/Alextibtab/Dungeons2_linux_fix/archive/refs/heads/main.tar.gz"
FIX_DIR="$HOME/.local/share/dungeons2-compat"
COMPAT_DIR="$HOME/.steam/root/compatibilitytools.d"

METHOD=gdk
DRY_RUN=0
for arg in "$@"; do
    case "$arg" in
        --alextibtab) METHOD=alextibtab ;;
        --dry-run)    DRY_RUN=1 ;;
        *) echo "Unknown option: $arg" >&2; exit 1 ;;
    esac
done

info() { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }
run() {
    if (( DRY_RUN )); then printf '\033[2m[dry-run]\033[0m %s\n' "$*"; else "$@"; fi
}

(( DRY_RUN )) && info "Dry run - nothing will be changed"
for tool in curl tar python3; do
    command -v "$tool" >/dev/null || die "$tool is required"
done

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# --- Find the game through Steam's library list (covers SD cards) ------------
LIB="" STEAM_ROOT=""
for root in "$HOME/.local/share/Steam" "$HOME/.steam/steam"; do
    vdf="$root/steamapps/libraryfolders.vdf"
    [[ -f "$vdf" ]] || continue
    while read -r path; do
        if [[ -f "$path/steamapps/appmanifest_$APPID.acf" ]]; then
            LIB=$path STEAM_ROOT=$root
            break 2
        fi
    done < <(sed -n 's/^[[:space:]]*"path"[[:space:]]*"\(.*\)"/\1/p' "$vdf")
done
[[ -n "$LIB" ]] || die "Minecraft Dungeons II isn't installed in Steam. Install it first, then rerun."
WIN64="$LIB/steamapps/common/Minecraft Dungeons II/Dungeons/Binaries/Win64"
[[ -d "$WIN64" ]] || die "Game folder missing: $WIN64 (try Verify Integrity in Steam)"
info "Found game in: $LIB"

# --- Alextibtab method: hand over to its own installer -----------------------
if [[ $METHOD == alextibtab ]]; then
    info "Downloading Alextibtab/Dungeons2_linux_fix into $FIX_DIR"
    run mkdir -p "$FIX_DIR"
    if (( DRY_RUN )); then
        run "curl $FIX_TARBALL | tar -xz --strip-components=1 -C $FIX_DIR"
    else
        curl -fsSL "$FIX_TARBALL" | tar -xz --strip-components=1 -C "$FIX_DIR"
    fi
    command -v unzip >/dev/null || die "unzip is required by the fix's install.sh"
    run env STEAM_ROOT="$STEAM_ROOT" sh "$FIX_DIR/install.sh"
    cat <<EOF

$(printf '\033[1;32mDone!\033[0m') Three things left:
  1. Sign in once (opens microsoft.com/link, enter the code shown):
       $FIX_DIR/.venv/bin/python3 $FIX_DIR/xauth.py
  2. In Steam: Minecraft Dungeons II > Properties > General > Launch Options:
       WINEDLLOVERRIDES="xgameruntime=n" %command%
  3. Properties > Compatibility > Proton Experimental (or Proton-GE)
EOF
    exit 0
fi

# --- 1. GDK-Proton -----------------------------------------------------------
info "Downloading GDK-Proton (~570 MB)..."
run mkdir -p "$COMPAT_DIR"
run curl -fL --progress-bar -o "$tmp/proton.tar.gz" "$PROTON_URL"
if [[ -d "$COMPAT_DIR/$PROTON_DIR" ]]; then
    info "Old $PROTON_DIR found, replacing it"
    run rm -rf "${COMPAT_DIR:?}/${PROTON_DIR:?}"
fi
run tar -xzf "$tmp/proton.tar.gz" -C "$COMPAT_DIR"
info "Installed $COMPAT_DIR/$PROTON_DIR"

# --- 2. XCurl.dll (from Microsoft's GDK package on NuGet) --------------------
info "Downloading XCurl.dll from Microsoft's GDK package (~135 MB)..."
run curl -fL --progress-bar -o "$tmp/gdk.nupkg" "$XCURL_NUPKG"
run python3 -c 'import sys, zipfile, shutil
with zipfile.ZipFile(sys.argv[1]).open(sys.argv[2]) as src, open(sys.argv[3], "wb") as dst:
    shutil.copyfileobj(src, dst)' "$tmp/gdk.nupkg" "$XCURL_IN_NUPKG" "$tmp/XCurl.dll"

old_dll=$(find "$WIN64" -maxdepth 1 -iname 'xcurl.dll' | head -n1)
if [[ -n "$old_dll" ]]; then
    if [[ -e "$WIN64/XCurl.dll.bak" ]]; then
        run rm -f "$old_dll"
    else
        run mv "$old_dll" "$WIN64/XCurl.dll.bak"
        info "Backed up original to XCurl.dll.bak"
    fi
fi
run cp "$tmp/XCurl.dll" "$WIN64/XCurl.dll"
info "Installed $WIN64/XCurl.dll"

cat <<EOF

$(printf '\033[1;32mDone!\033[0m') Now in Steam:
  1. Restart Steam (Steam menu > Exit, then open it again)
  2. Minecraft Dungeons II > Properties > Compatibility
  3. Tick "Force the use of a specific Steam Play compatibility tool"
  4. Pick: $PROTON_STEAM_NAME

To undo the DLL swap: mv "$WIN64/XCurl.dll.bak" "$WIN64/XCurl.dll"
EOF
