# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!


# configディレクトリはrailsアプリケーションの設定に関するファイルを保存するディレクトリ。

# environmentsディレクトリはプロジェクトの実行環境ごとの設定ファイルを保存している。
# railsの環境は、開発環境（development）、テスト環境(test)、本番環境(production)の３つがある。
# rails sやrails cなどrailsコマンドを実行する際に環境の指定がない場合は、デフォルトで開発環境（development）となる。



# users_contoller#newでlogger.debug(user_from_params)をすると最初にRails.application.initialize!が読み込まれていた。

# Rails.application.initialize! について
# Railsガイドより
# config/application.rbの残りの行ではRails::Applicationの設定を行います。この設定はアプリケーションの初期化が完全に完了してから使用されます。config/application.rbがRailsの読み込みを完了し、
# アプリケーションの名前空間が定義されると、制御はふたたびconfig/environment.rbに戻ります。ここではRails.application.initialize!によるアプリケーションの初期化が行われます。
# これはrails/application.rbで定義されています。
