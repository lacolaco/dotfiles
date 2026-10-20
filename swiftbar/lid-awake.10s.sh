#!/bin/bash
# <swiftbar.title>Lid Awake</swiftbar.title>
# <swiftbar.desc>蓋を閉じてもスリープしない状態 (pmset disablesleep) をトグルする</swiftbar.desc>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

set -u

# 切り替え時は macOS の管理者認証ダイアログが出る
set_disablesleep() {
  osascript -e "do shell script \"/usr/bin/pmset -a disablesleep $1\" with administrator privileges"
}

case "${1:-}" in
  on)  set_disablesleep 1; exit ;;
  off) set_disablesleep 0; exit ;;
esac

disabled=$(pmset -g | awk '/SleepDisabled/ {print $2}')
battery=$(pmset -g batt | grep -Eo '[0-9]+%' | head -n1)

if [ "$disabled" = "1" ]; then
  echo "| sfimage=cup.and.saucer.fill"
  echo "---"
  echo "スリープ無効 (蓋を閉じても起動したまま)"
  echo "バッテリー: ${battery:-不明}"
  echo "スリープを有効に戻す | bash='$0' param1=off terminal=false refresh=true"
else
  echo "| sfimage=moon.zzz"
  echo "---"
  echo "通常 (蓋を閉じるとスリープ)"
  echo "スリープを無効にする | bash='$0' param1=on terminal=false refresh=true"
fi
