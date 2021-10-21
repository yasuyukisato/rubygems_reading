EmailConfirmationMailer = Struct.new(:user_id) do
  def perform
    user = User.find(user_id)

    if user.confirmation_token
      Mailer.email_confirmation(user).deliver
    else
      Rails.logger.info("[jobs:email_confirmation_mailer] confirmation token not found. skipping sending mail for #{user.handle}")
    end
  end
end

# Structを使うと、データを保持するための単純なクラスを手軽に作ることができる
# とはいえ、普通のクラスとStructで作ったクラスをどのように使い分けるのかは判断が難しいところで
# 一般的には「わざわざ明示的にクラスを定義するほどでもないケースに向いている」などと言われる

# Structを使ってUserクラス（Userの構造体）を作成する

# Structクラスから作成されたUserクラスを使う
# user = User.new('Alice', 'Ruby')

# 属性を参照する
# user.first_name
# => "Alice"
# user.last_name
# #=> "Ruby"

# 属性を変更する
# user.last_name = 'Python'
# user.last_name
# #=> "Python"

# Struct.new(:first_name, :last_name).class #=> Class
