#!/bin/bash
# $?は直前のコマンドの終了ステータスを保持している。
# 0なら成功
# 1なら失敗
# 127だとそんなコマンドねーよになる。
if test $? -eq 0 ; then
  echo "(U^ω^)"
else
  history -d $(( $HISTCMD - 1 ))
  echo "(´；ω；｀)"
fi
