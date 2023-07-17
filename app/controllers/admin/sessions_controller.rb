class Admin::SessionsController < Devise::SessionsController
  def create
    super do |admin|
      # 管理者ログイン成功後にカスタムロジックを追加する場合はここに記述します。
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super do |admin|
      # 管理者ログアウト成功後にカスタムロジックを追加する場合はここに記述します。
    end
  end

  def after_sign_in_path_for(resource)
    admin_homes_top_path
  end

  private

  def after_sign_out_path_for(resource)
    admin_session_path
  end

end
