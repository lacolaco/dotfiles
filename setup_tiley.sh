#! /bin/zsh -eux

echo "=== setup Tiley"

# Tiley (https://github.com/yusuke/tiley) の設定を書き込む。
# TileyはUserDefaultsに設定を保存するため、symlinkではなくdefaults writeで管理する。
# アプリ内で設定を変えた場合は、このスクリプトへ手で反映すること。

# 起動中に書き込むと終了時に上書きされるため、先に止めて終了を待つ
pkill -x Tiley || true
for _ in {1..25}; do
  pgrep -x -q Tiley || break
  sleep 0.2
done
if pgrep -x -q Tiley; then
  echo "Tiley did not exit within 5s. Quit it manually and rerun." >&2
  exit 1
fi

# グリッド: 6x6 (Divvyからの移行値)
defaults write one.cafebabe.tiley gridColumns -int 6
defaults write one.cafebabe.tiley gridRows -int 6

# グローバルホットキー: Cmd+Shift+/ (keyCode 44, Carbon修飾キー cmd(256)+shift(512))
defaults write one.cafebabe.tiley globalHotKeyCode -int 44
defaults write one.cafebabe.tiley globalHotKeyModifiers -int 768

echo "Tiley setup completed. Launch Tiley.app and grant accessibility permission if needed."
