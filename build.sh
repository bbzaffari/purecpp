#!/usr/bin/env bash

set -euo pipefail

cd src/

#================= COLORS =================
GREEN='\033[0;32m'
RESET='\033[0m'

#-----------------------------------------
#================= LOGGING ===============
#-----------------------------------------
TAG="[$(basename "${BASH_SOURCE[0]}")]"
LINE_BRK=$'\n\n'
SEGMENT=$'===========================================================\n'
#-----------------------------------------

#-----------------------------------------
printf "$SEGMENT$SEGMENT$SEGMENT"
printf "         Begin: $TAG$LINE_BRK"
printf "$SEGMENT$LINE_BRK"
#-----------------------------------------



# ────────────────────────────────────────
# Smart core splitter for parallel builds
# ────────────────────────────────────────

cores=$(nproc)

if [ "$cores" -gt 1 ]; then
    half=$((cores / 2))
else
    half=1
fi
printf "$LINE_BRK"
echo -e "$GREEN[Core splitter] Detected $cores cores, using $half for parallel build. "
printf "$LINE_BRK$SEGMENT$SEGMENT"

#-----------------------------------------

# ────────────────────────────────────────
# Conan
# ────────────────────────────────────────
#-----------------------------------------
printf "         Begin: [CONAN]$LINE_BRK"
printf "$SEGMENT"
printf "$LINE_BRK"
#-----------------------------------------

rm -fr ./build 
conan install . --build=missing -c tools.build:jobs=$half

# rm -fr ./conan.lock
# conan lock create . --build=missing -c tools.build:jobs=$half

#-----------------------------------------
printf "$SEGMENT"
printf "          [CONAN] Finished \n"
printf "$SEGMENT$SEGMENT$SEGMENT\n"
#================= ENDING ================

# ────────────────────────────────────────
# Build
# ────────────────────────────────────────
#-----------------------------------------
printf "            Begin: [Build]$LINE_BRK"
printf "$SEGMENT$LINE_BRK"
#-----------------------------------------
START_TIME=$(date +%s)

cmake -DCMAKE_POLICY_DEFAULT_CMP0091=NEW \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
    -DBUILD_SHARED_LIBS=OFF \
    -D_GLIBCXX_USE_CXX11_ABI=1 \
    -DSPM_USE_BUILTIN_PROTOBUF=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=generators/conan_toolchain.cmake \
    -S "$(pwd)" \
    -B "$(pwd)/build/Release" \
    -G "Unix Makefiles"

cmake --build "$(pwd)/build/Release" --parallel "$half" #--target RagPUREAI 

END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
#---------------- LOG --------------------
echo -e "$GREEN"
echo    "==========================================================="
echo    "      Total build time: ${ELAPSED_TIME} s"
echo -e "===========================================================$RESET"

#-----------------------------------------
printf "$SEGMENT"
printf "       [Build] Finished \n"
printf "$SEGMENT$SEGMENT$SEGMENT\n"
#================= ENDING ================


# ────────────────────────────────────────
# Sending to Sandbox
# ────────────────────────────────────────

printf "$GREEN[Last Step] Sending to Sandbox \n"
echo -e "$RESET"

rm -f ../Sandbox/*.so

cp ./build/Release/RagPUREAI.cpython*.so ../Sandbox/

#-----------------------------------------
printf "$SEGMENT"
printf "          $TAG Finished \n"
printf "$SEGMENT$SEGMENT$SEGMENT\n"
#================= ENDING ================
