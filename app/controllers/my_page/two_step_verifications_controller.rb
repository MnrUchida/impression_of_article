module MyPage
  class TwoStepVerificationsController < ApplicationController
    def new
      issuer = 'YourAppName'
      label = "#{issuer}:#{current_user.email}"

      uri = current_user.otp_provisioning_uri(label, issuer: issuer)

      @qr_code = RQRCode::QRCode.new(uri)
                                .as_png(resize_exactly_to: 200)
                                .to_data_url
    end

    def create
      if current_user.otp_required_for_login
        current_user.otp_required_for_login = false
      else
        unless current_user.validate_and_consume_otp!(params[:otp_attempt])
          flash[:notice] = "認証できませんでした"
          redirect_to new_my_page_two_step_verification_url
          return
        end
        current_user.otp_required_for_login = true
      end
      current_user.save!

      flash[:notice] = "変更しました"
      redirect_to root_url
    end
  end
end
