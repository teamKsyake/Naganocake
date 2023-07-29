# app/controllers/public/customers_controller.rb
class Public::CustomersController < ApplicationController
  # ログイン済みでなければログイン画面にリダイレクトする
  before_action :authenticate_customer!

  def show
    @customer = current_customer
  end

  def edit
    # 編集用のフォームを表示するために、現在の顧客情報を取得します
    @customer = current_customer
  end

  def update
    # 編集フォームから送信されたパラメータで顧客情報を更新します
    @customer = current_customer
    if @customer.update(customer_params)
      redirect_to customers_mypage_path notice: "登録情報を更新しました。"
    else
      render :edit
    end
  end

  def check
    # 退会確認画面を表示するだけなので、特に処理は必要ありません
  end

  public

  def withdrawal
    if params[:customer].present? # フォームにメールアドレスを送信した場合
      @customer = Customer.find_by(email: params[:customer][:email])
    if @customer&.valid_password?(params[:customer][:password])
      @customer.update(withdrawn: true)
      sign_out @customer # 退会処理後に自動でログアウトさせる
      redirect_to customers_withdrawal_path, notice: "退会処理が完了しました。ご利用いただきありがとうございました。"
    else
      redirect_to customers_check_path, alert: "パスワードが間違っています。もう一度入力してください。"
    end
  else # フォームにメールアドレスを送信しない場合
      @customer = current_customer
      @customer.update(withdrawn: true)
      sign_out @customer # 退会処理後に自動でログアウトさせる
      redirect_to customers_withdrawal_path, notice: "退会処理が完了しました。ご利用いただきありがとうございました。"

  end
end


  private


  def customer_params
    params.require(:customer).permit(:email, :last_name, :first_name, :last_name_kana, :first_name_kana, :postcode, :address, :phone_number)
  end
end