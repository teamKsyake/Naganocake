class Admin::SessionsController < Devise::SessionsController
  # POST /resource/sign_in
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
    admin_root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end

end