# my_history

## こういうのつくりたい
1. `.bash_history`には（あるいは`history`のキャッシュには)重複コマンドは保存しない
2. 重複していた場合は古い方を消して最下行へ履歴を追加
3. `.bash_hisotry`はコマンド実行される都度`history -a`される-> `.bash_history`は常に最新
e. `.bash_history`は、使用されるスペースの数を区別しない( 例： `ls` と `ls　` は同一)
5. ミスコマンド(`$? != 0`)は保存しない

## 普通のhistoryはこう
1. コマンドが実行される
2. ヒストリーのキャッシュの最下行に実行したコマンドが追加される
3. `exit`したり`history -a`したりするとキャッシュが`.bash_history`にコピーされる

## my_historyはこう
1. コマンドが実行される
2. ヒストリーの・キャッシュの最下行に実行したコマンドが追加される
3. コマンド失敗時は*最下行のコマンドは追加されない*
4. コマンド成功時は*既存コマンドならば古い方を~/.bash_historyから消去する*
5. `exit`したり`history -a`したりするとキャッシュが`.bash_history`にコピーされる

## 3.ってどうやんの

3. *ただし、実行時ミスしたコマンドは追加されない*

```sh
[YOUR CMD] || history -d $(( $HISTCMD - 1 ))
```
終了ステータスコードは成功時0.

### じゃあどうすんの

わからんｗ

- コマンドを全部配列の中にいれてしまう案（だめかな？)
- `$?`だけ`checkLastStatus.sh`の外側に置いて引数として渡す。
  - つまり`[YOUR CMD] ; echo $? | checkLastStatus.sh`みたいな感じ。
- `hoge.sh`の中で $HISTCMDを参照すると0になる。

## 5.ってどうやんの

5. *既存のコマンドは古い方をhistoryから消去する*

これはひとつ前のコマンドが`.bash_hsitory`にあれば消してくれるコマンド。

 ```bash
unpoko=`fc -ln $(( $HISTCMD - 1 )) | cut -f 2 | cut -c 2- `;
unpoko=`grep -wn "^${unpoko}\s*$" ~/.bash_history | cut -d ':' -f 1` ;
sed -i -e ${unpoko},${unpoko}d ~/.bash_history
```

TODO: grepで反応無かったらsedしない

ソートしないで重複行を消す<http://qiita.com/arcizan/items/9cf19cd982fa65f87546>
> `awk '!a[$0]++' FILE`


