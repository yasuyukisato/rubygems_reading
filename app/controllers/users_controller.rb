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
      # 確認メールを送っている
      flash[:notice] = t(".email_sent")
      redirect_back_or url_after_create
    else
      render template: "users/new"
    end
  end

  private

  def user_params
    params.permit(user: Array(User::PERMITTED_ATTRS)).fetch(:user, {})
  end
end
