module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      {
        provider: provider.to_s,
        uid: "123545",
        info: {
          name: "test user",
          email: "test@example.com"
        },
        credentials: {
          token: "mock_token",
          secret: "mock_secret"
        }
      }
    )
  end
end
