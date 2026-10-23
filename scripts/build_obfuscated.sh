#!/usr/bin/env bash
# ==============================================================================
# Build with Full Dart Obfuscation, R8 Minification & Resource Shrinking
#
# Usage:
#   bash scripts/build_obfuscated.sh [apk|appbundle]
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
EXAMPLE_DIR="$REPO_ROOT/example"
TARGET="${1:-apk}"
SYMBOLS_DIR="$EXAMPLE_DIR/build/app/outputs/symbols"

echo "=============================================================================="
echo " Flutter Face Liveness — Hardened Release Build"
echo "=============================================================================="
echo "Target:             $TARGET"
echo "Debug Symbols Dir:  $SYMBOLS_DIR"
echo "Workdir:            $EXAMPLE_DIR"
echo "=============================================================================="

cd "$EXAMPLE_DIR"

# Ensure output directory for symbols exists
mkdir -p "$SYMBOLS_DIR"

echo "Running flutter pub get in example..."
flutter pub get

echo "Building release $TARGET with Dart obfuscation and R8 minification..."
if [ "$TARGET" = "appbundle" ]; then
  flutter build appbundle \
    --release \
    --obfuscate \
    --split-debug-info="$SYMBOLS_DIR" \
    --android-skip-build-dependency-validation
  ARTIFACT_PATH="build/app/outputs/bundle/release/app-release.aab"
else
  flutter build apk \
    --release \
    --obfuscate \
    --split-debug-info="$SYMBOLS_DIR" \
    --android-skip-build-dependency-validation
  ARTIFACT_PATH="build/app/outputs/flutter-apk/app-release.apk"
fi

echo ""
echo "=============================================================================="
echo " Build Completed Successfully!"
echo "=============================================================================="

if [ -f "$ARTIFACT_PATH" ]; then
  SIZE=$(du -h "$ARTIFACT_PATH" | awk '{print $1}')
  echo "Artifact:           $ARTIFACT_PATH ($SIZE)"
fi

echo "Symbols Saved:      $SYMBOLS_DIR"
echo ""
echo "Obfuscation Verification:"
echo "1. Dart symbol maps generated in $SYMBOLS_DIR:"
ls -lh "$SYMBOLS_DIR" 2>/dev/null || echo "No symbols directory found."
echo ""
echo "To de-obfuscate a stack trace from this release build:"
echo "  flutter symbolize -i <stack_trace.txt> -d $SYMBOLS_DIR"
echo "=============================================================================="
