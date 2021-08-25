DokodemoDrag
=====================

Macでは、ウィンドウを移動したりリサイズする際、マウスカーソルを移動するのがわずらしくありませんか？

DokodemoDragを使うとウィンドウのどこにマウスカーソルがあっても、移動とリサイズが簡単に行えます。

![image01](https://github.com/hmuronaka/DokodemoDrag/blob/images/docs/images/image01.gif)

使い方は以下の通り、とても簡単です。

|アクション|操作方法|
|:---|:---|
|ウィンドウの移動|ウィンドウの任意の場所にマウスカーソルを置き、Commandキーを押しながらマウスでドラッグする|
|ウィンドウのリサイズ|ウィンドウの任意の場所にマウスカーソルを置き、Command+Shiftキーを押しながらマウスをドラッグする|

# 要件

macOS version 11.2+

# インストールと初回起動方法

1. GitHubのこのリポジトリからアプリの入った[zipファイルをダウンロード](https://github.com/hmuronaka/DokodemoDrag/releases/download/0.2/DokodemoDrag.app.zip)します。
2. zipファイルを解凍して、DokodemoDrag.appをApplicationフォルダに移動します。
3. FinderのApplicationから右クリックでDokodemoDragを起動します(起動するとメニューバー右上にアイコンが表示されます）。
4. MacOSの[システム環境設定]=>[セキュリティとプラバシー]を開きます。[プライバシー]タブを開き[アクセシビリティ]を選択して、DokodemoDrag.appを有効にします。

<img src="https://github.com/hmuronaka/DokodemoDrag/blob/images/docs/images/jp/privacy_accessibility.png" width="400px">

5. メニューバーのアイコンをクリックしてアプリを終了します。

<img src="https://github.com/hmuronaka/DokodemoDrag/blob/images/docs/images/jp/menu_quit.png" width="260px">

6. 再度アプリケーションからDokodemoDrag.appを起動します。

以後は、OSログイン時に自動起動します。

# アンインストール方法

Finderから、アプリケーションに追加したDokodemoDrag.appを削除します。

# 設定と操作

メニューバー上のメニューから、以下の設定と操作が行えます。

|メニュー|内容|
|:--|:--|
|有効にする / 無効にする|DokodeomoDragのウィンドウ操作の有効/無効を設定できます|
|ログイン時に起動する|チェックが入っているとOSログイン時に自動的にDokodemoDrag.appを起動します(デフォルトはチェックが入っています）。|
|終了する|DokodemoDragを終了します。|

# その他

## キーボードのキー設定について

MacOSの日本語キーボードの配置だとCommandキーは（個人的には）押しづらい位置にあるので、もしCaps Lockキーを頻繁に利用しないのであれば、
Caps LockキーのアクションをCommandに変更すると使いやすくなるかもしれません。

設定方法は以下の通りです。

1. MacOSの[システム環境設定]から[キーボード]を開く
2. [修飾キー]を開く
3. Caps LockキーのアクションをCommandに変更する。

<img src="https://github.com/hmuronaka/DokodemoDrag/blob/images/docs/images/jp/key_modifiers.png" width="400px">

## 開発に当たって参考にした情報など

このアプリの実装の多くは、Macのウィンドウをキーボードショートカットから配置できる[Rectangle](https://github.com/rxhanson/Rectangle)を参考にしています。
またRectangle, 公式ドキュメント以外にネット上に公開されている記事を参考にしています。
いくつかを備忘録として記載します。

- [「ログイン時に起動」を実装する](https://questbeat.hatenablog.jp/entry/2014/04/19/123207)
- [macOS Cocoa Appでマウス操作を常に受け取る](https://www.shujima.work/entry/2019/07/07/132138)
- [ステータスバー常駐アプリ](http://saokkk.seesaa.net/article/443713479.html)

※ ログイン時の自動起動はcodesign等の兼ね合いから、[sindresorhus/LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin)の利用を検討した方が良いかもしれません。

また開発する過程で同機能のアプリの存在も知ったので、参考までに記載します。

- [dmarcotte/easy-move-resize](https://github.com/dmarcotte/easy-move-resize)
- [keith/ModMove](https://github.com/keith/ModMove)

## NSWindowShouldDragOnGesture を知っていますか？

余談ですが、 ウィンドウの任意の場所をドラッグしてウィンドウを移動するだけなら、MacOSのNSWindowShouldDragOnGestureという機能を有効にするだけでよく、アプリは不要です。

以下はその設定方法です。

1. Terminal.appを開く
2. 以下のコマンドを実行する

```sh
defaults write -g NSWindowShouldDragOnGesture -bool true
```

3. MacOSを再起動する

これでアプリ不要で、ウィンドウの移動が簡単にできるようになります。(ウィンドウ移動はCommand+CTRLキーです）

この機能を無効にする場合は、Terminal.appから以下のコマンドを実行します。

```sh
defaults delete -g NSWindowShouldDragOnGesture
```

実行した後にMacOSを再起動します。

DokodemoDragを利用する場合、NSWindowShouldDragOnGestureは無効にすることをお勧めします。

参考記事: [Usability hack: Click & drag anywhere in macOS windows to move them](https://www.mackungfu.org/UsabilityhackClickdraganywhereinmacOSwindowstomovethem)


# ライセンス
MIT License
