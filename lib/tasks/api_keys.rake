namespace :api_keys do
  desc "Migrate user api keys to ApiKey model"
  # ユーザーテーブルのAPIキーをApiKeyモデルに移行する
  task migrate: :environment do
    users = User.where.not(api_key: nil).all
    # api_keyがnilではないuser情報を取得

    total = users.count
    i = 0
    puts "Total: #{total}"
    users.find_each do |user|
      begin
        hashed_key = Digest::SHA256.hexdigest(user.api_key)
        # # user.api_keyを変換し、16進数で出力
        scopes_hash = ApiKey::API_SCOPES.index_with { true }
        # ApiKeyモデルのAPI_SCOPES定数をキーとして、値にtrueをいれる
        # => {:index_rubygems=>true, :push_rubygem=>true, :yank_rubygem=>true, :add_owner=>true, :remove_owner=>true, :access_webhooks=>true, :show_dashboard=>true}

        api_key = user.api_keys.new(scopes_hash.merge(hashed_key: hashed_key, name: "legacy-key"))
        # has_many :api_keys ハッシュを結合
        api_key.save(validate: false)
        # api_keysテーブルに保存 #バリーデーションを一時的にoff
        puts "Count not create new API key: #{api_key.inspect}, user: #{user.handle}" unless api_key.persisted? #保存済みかチェックするメソッド
      rescue StandardError => e
        puts "Count not create new API key for user: #{user.handle}"
        puts "caught exception #{e}! ohnoes!"
      end

      i += 1
      print format("\r%.2f%% (%d/%d) complete", i.to_f / total * 100.0, i, total)
    end
    puts
    puts "Done."
  end
end


# find_eachメソッド
# 大量のレコードを処理する際に,メモリの消費量を抑えることができる
# デフォルトでレコードを1000件ごとに取得する
# 取得したレコードはモデルのインスタンスとして１件ずつブロックに渡される
# 1000件の処理が終わったら、次の1000件を取得して処理をする


# requireは不要
# Digestモジュールとは、ハッシュ値を作成するためのモジュールです。Digestモジュールを使えば、MD5やSHA2などのアルゴリズムでハッシュ値を生成することができます。
# ちなみにハッシュ値とは、あるデータを変換して得られるデータを指します。データを一方向にしか変換できないのが特徴で、ハッシュ値から元のデータを復元したり、推測したりできないようになっています。
# Webサービスだと、パスワードの保存などで用いられます。また、ブロックチェーンを支える重要な技術でもあります。


# Enumerable#index_with{...}
# ブロックを指定して呼び出すと、各要素をキーとして、ブロックを評価した結果を値とするHashを生成します。
# irb(main):001:0> %w[a b].index_with{|e| e.upcase}
# => {"a"=>"A,", "b"=>"B"}

# mergeメソッド 
# ハッシュを結合する
# “ハッシュオブジェクト.merge(追加するハッシュオブジェクト)”

# hash1 = {"経済学" => 80, "財政学" => 70, "会計学" => 60}
# hash2 = {"経営学" => 75, "会社法" => 65}
# hash3 = hash1.merge(hash2)

# p hash3
# => {"経済学"=>80, "財政学"=>70, "会計学"=>60, "経営学"=>75, "会社法"=>65}
# p hash1 #=> {"経済学"=>80, "財政学"=>70, "会計学"=>60}
# p hash2 #=> {"経営学"=>75, "会社法"=>65}

# merge!メソッドを使用すると破壊的な変更が起こる/hash1,2が統合後の値に置き換わる


# inspectメソッド
# オブジェクトや配列などをわかりやすく文字列で返してくれるメソッド