## これはなに？
[docomoの製品アップデート情報](http://www.nttdocomo.co.jp/support/utilization/product_update/list/index.html?s=date)を取得し、更新があればメールで通知します。Ruby 2.0.0-p0 以上で動きます。

## どうやってつかうの？
1. `bundle install`
1. `cp config/email_delivery.yml.example config/email_delivery.yml`
1. `config/email_delivery.yml` にSMTPサーバの設定とかを書きます。
1. cron とかつかって適当な間隔で走らせてあげます。
1. メールがきます。
