class Public::UsersController < ApplicationController
  # ログイン済みuserのみアクセス許可
  before_action :authenticate_user!
  # ゲストユーザーの情報編集制限
  before_action :ensure_guest_user, only: [:edit, :update]
  # 他ユーザ情報編集へのアクセス制限
  before_action :correct_user,      only: [:edit, :update, :destroy]
  # 相互フォロー以外、累計食肉へのアクセス制限
  before_action :friend_user, only: [:user_meat]

  # user詳細画面
  def show
    @user          = User.find(params[:id])
    @tweets        = @user.tweets.all.order(created_at: :desc).page(params[:page]).per(5)
    @tweets_all    = @user.tweets.all
    @total_weights = @tweets_all.group(:meat_id).sum(:once_weight)
    @user_achievement = @user.user_achievements.find_by(on_display: true)
    if @user_achievement.present?
      @achievement = @user_achievement.achievement.title
    else
      @achievement = "称号未設定"
    end
  end
  # user情報編集画面
  def edit
    @user = User.find(params[:id])
  end
  # 退会確認画面
  def confirm
    @user = current_user
  end
  # user累計食肉画面
  def user_meat
    @user          = User.find(params[:id])
    @tweets        = @user.tweets.all
    @total_weights = @tweets.group(:meat_id).sum(:once_weight)
  end
  # user情報更新
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
      flash[:notice] = "登録情報の編集が完了しました。"
    else
      render :edit
    end
  end
  # user情報削除
  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to root_path
    flash[:notice] = "退会処理、全データの削除が完了しました。"
  end

  private

  def user_params
    params.require(:user).permit(:nick_name, :introduction, :profile_image, :phone_number, :email)
  end
  # ゲストユーザーの情報編集制限
  def ensure_guest_user
    user = User.find(params[:id])
    if user.email == "guest@example.com"
      redirect_to user_path(current_user)
      flash[:notice] = "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
  # 他ユーザ情報編集へのアクセス制限
  def correct_user
    user = User.find(params[:id])
    if user != current_user
      redirect_to user_path(current_user)
      flash[:notice] = "指定されたURLにはアクセスできません"
    end
  end

  def friend_user
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user) || user == current_user
      redirect_to user_path(user)
      flash[:notice] = "相互フォロー者以外、アクセスできません。"
    end
  end

end
