# my_history

## こういうの
1. .bash_historyには（あるいはhistoryのキャッシュには)重複コマンドは保存しない
2. 重複していた場合は古い方を消して最下行へ履歴を追加
3. .bash_hisotryはコマンド実行される都度'history -a'される-> .bash_historyは常に最新
4. .bash_historyは、使用されるスペースの数を区別しない( 例： 'ls ' と 'ls' は同一)
5. ミスコマンドは保存しない

## 普通のhistoryはこう
1. コマンドが実行される
2. ヒストリーのキャッシュの最下行に実行したコマンドが追加される
3. exitしたりhistory -aしたりするとキャッシュが.bash_historyにコピーされる

## このhistoryはこう
1. コマンドが実行される
2. ヒストリーの・キャッシュの最下行に実行したコマンドが追加される
3. *ただし、実行時ミスしたコマンドは追加されない*
4. exitしたりhistory -aしたりするとキャッシュが.bash_historyにコピーされる
5. *その時、追加差分に対して重複確認を行い、古い方の履歴を消去する。*

## 俺にはビルトインのhistoryに手を加える能力はないぞ
ないぞい。

## 3.ってどうやんの

```sh
unpoko; my_history/checkEndStatus.sh
```
my_history/checkEndStatus.shはこいつは終了時ステータス$?をモニタして成功時である1以外であればhistory -d $(($HISTCMD - 1))で直近の履歴を消してくれる。
恐らく、$?は直前のコマンドの成否を保存しているわけだが、
checkEndStatus.shが実行された時点で更新されてしまうのだ。
なので、面倒だが、checkEndStatus.shの内容を都度全て入力する必要がある。

つまり、
```sh
unpoko ; if test $? -eq 0 ; then echo "(U^ω^)" ; else history -d $(( $HISTCMD - 1 )) ; echo "(´；ω；｀)" ; fi
```
こういうの。
ひとつ前のコマンドの成否によってhistory -d したりしなかったりする。
