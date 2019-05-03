class SessionsController < ApplicationController
  # ログイン画面を表示するアクションに対しては、定義済みのフィルターを通らないようにする
  skip_before_action :login_required

  def new
  end

  def create
    # 送られてきたメールアドレスでユーザを検索
    # findメソッドの場合、nilが入るとエラーが発生する。セッションが消えている場合エラーが起こってしまう。
    user = User.find_by(email: session_params[:email])

    # ユーザーが見つかった場合は送られてきたパスワードによる認証をメソッドを用いて行う
    # &.: nilガード
    if user&.authenticate(session_params[:password])
      # セッションにuser_idを格納
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました。'
    else
      render :new
    end
  end

  def destroy
    # セッション内の情報を全て削除
    reset_session

    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private
  # リクエストパラメータとして送られてきた情報が想定通りであるかチェックし、受け付ける想定箇所だけを抜くとる
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
