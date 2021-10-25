class UsersController < Clearance::UsersController
  def new
    @user = user_from_params
    # @userにはUserクラスのインスタンスが入っていた
    # logger.debug(user_from_params)
    # 結局user_from_paramsがどこから来ているのかは謎
  end

  def create
    @user = user_from_params
    if @user.save
      Delayed::Job.enqueue EmailConfirmationMailer.new(@user.id)  # email_confirmation_mailer.rb 1
      # ジョブを起動し、確認メールを送っている
      flash[:notice] = t(".email_sent")
      redirect_back_or url_after_create
    else
      render template: "users/new"
    end
  end

  # enqueue(エンキュー) → キューに追加する操作

  private

  def user_params
    params.permit(user: Array(User::PERMITTED_ATTRS)).fetch(:user, {})
  end
end

# パラメータデバック
# "user"=>{"email"=>"xxxx@mail.com", "handle"=>"sato", "password"=>"hogehoge"}, "commit"=>"新規登録", "format"=>"html", "controller"=>"users", "action"=>"create"} permitted: false>

# # fetchメソッド
# params.fetch(:user, {})は、params[:user]が空の場合{}を,params[:user]が空でない場合、params[:user]を返す


# User::PERMITTED_ATTRS → userクラス

# PERMITTED_ATTRS = %i[
#   bio
#   email
#   handle
#   hide_email
#   location
#   password
#   website
#   twitter_username
# ].freeze


