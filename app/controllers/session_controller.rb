class SessionController < ApplicationController
  def new
  end

  def create
    # 送られてきたメールアドレスでユーザを検索
    # findメソッドの場合、nilが入るとエラーが発生する。セッションが消えている場合エラーが起こってしまう。
    user = User.find_by(email: session_params[:email])

    # ユーザーが見つかった場合は送られてきたパスワードによる認証をメソッドを用いて行う
    # &.: nilガード
    if user&.autheticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: 'ログインしました。'
    else
      render :new
    end
  end

  private
  # リクエストパラメータとして送られてきた情報が想定通りであるかチェックし、受け付ける想定箇所だけを抜くとる
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
