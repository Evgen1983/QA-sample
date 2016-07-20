module OmniauthMacros
  
  def mock_auth_sucsess(provider)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      provider: provider.to_s,
      uid: '123456'
    }.merge(provider == :facebook ? { info: { email: 'user@email.com' }} : {}))
  end
  
   def mock_auth_invalid(provider)
    OmniAuth.config.mock_auth[provider] = :invalid_credentials
  end
end