#!/bin/bash

origin_helper_path="$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/LaunchAtLogin.framework/Resources/LaunchAtLoginHelper.app"
helper_dir="$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/Library/LoginItems"
helper_path="$helper_dir/LaunchAtLoginHelper.app"

rm -rf "$helper_path"
mkdir -p "$helper_dir"
cp -rf "$origin_helper_path" "$helper_dir/"

defaults write "$helper_path/Contents/Info" CFBundleIdentifier -string "$PRODUCT_BUNDLE_IDENTIFIER-LaunchAtLoginHelper"

if [[ -z "$EXPANDED_CODE_SIGN_IDENTITY_NAME" ]]; then
	echo "EXPANDED_CODE_SIGN_IDENTITY_NAME: empty"
else
	echo "EXPANDED_CODE_SIGN_IDENTITY_NAME: $EXPANDED_CODE_SIGN_IDENTITY_NAME"
	codesign --force --sign="$EXPANDED_CODE_SIGN_IDENTITY_NAME" "$helper_path"
fi

if [[ $CONFIGURATION == "Release" ]]; then
	rm -rf "$origin_helper_path"
	rm "$(dirname "$origin_helper_path")/copy-helper.sh"
fi
