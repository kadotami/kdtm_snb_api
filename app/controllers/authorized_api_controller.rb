class AuthorizedApiController < ApplicationController
   # JWT で認証したユーザ（提督）の情報を返すメソッド
  def current_user
    @jwt_current_user ||= Users.find(@user_id)
  end

  # Authorization ヘッダに含まれる JWT で認証状態をチェックするためのメソッド
  def jwt_authenticate
    unless jwt_bearer_token
      response.header['WWW-Authenticate'] = 'Bearer realm="User Stats"'
      render json: { errors: [ { message: 'Unauthorized' }]}, status: :unauthorized
      return
    end

    unless jwt_decoded_token
      response.header['WWW-Authenticate'] = 'Bearer realm="User Stats", error="invalid_token"'
      render json: { errors: [ { message: 'Invalid token' } ] }, status: :unauthorized
      return
    end

    unless @jwt_user_id
      # 有効期限の検査
      jwt_user_id = jwt_decoded_token[0]['id']
      if UserToken.where(user_id: jwt_user_id, token: jwt_bearer_token).exists?
        @jwt_user_id = jwt_user_id
      else
        response.header['WWW-Authenticate'] = 'Bearer realm="User Stats", error="invalid_token"'
        render json: { errors: [ { message: 'Expired token' } ] }, status: :unauthorized
      end
    end
  end

  # Authorization ヘッダの Bearer スキームのトークンを返します。
  def jwt_bearer_token
    @jwt_bearer_token ||= if request.headers['Authorization'].present?
                            scheme, token = request.headers['Authorization'].split(' ')
                            (scheme == 'Bearer' ? token : nil)
                          end
  end

  # JWT をデコードした結果を返します。
  def jwt_decoded_token
    begin
      # verify_iat を指定しても、実際には何も起こらない
      # iat を含めない場合も、iat が未来の日付の場合も、エラーは発生しなかった
      @jwt_decoded_token ||= JWT.decode(
          jwt_bearer_token,
          Rails.application.secrets.secret_key_base,
          { :verify_iat => true, :algorithm => 'HS256' }
      )
    rescue JWT::DecodeError, JWT::VerificationError, JWT::InvalidIatError
      # エラーの詳細をクライアントには伝えないため、常に nil を返す
      nil
    end
  end

  before_action :jwt_authenticate
end