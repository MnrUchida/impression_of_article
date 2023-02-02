module OauthConnection
  def self.build_client(client_id:, client_secret:)
    OAuth2::Client.new(client_id, client_secret,
                       site: 'http://mastodon.local')
  end

  def self.get_token(code:, client_id:, client_secret:, callback_url:)
    client = build_client(client_id: client_id, client_secret: client_secret)
    client.auth_code.get_token(code.to_s,
                               client_id: client_id,
                               client_secret: client_secret,
                               redirect_uri: callback_url,
                               headers: {'Authorization' => 'Basic some_password'})
  end

  def self.restore_token(client_id:, client_secret:, token:, callback_url:)
    client = build_client(client_id: client_id, client_secret: client_secret)
    token = OAuth2::AccessToken.from_hash(client, token)
    if token.expired?
      token = token.refresh!
    end
    token
  end
end
