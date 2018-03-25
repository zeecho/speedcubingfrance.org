module ApplicationHelper
  def wca_base_url
    ENV['WCA_BASE_URL'] || "http://localhost:1234"
  end

  def wca_token_url
    "#{wca_base_url}/oauth/token"
  end

  def wca_api_url(resource)
    "#{wca_base_url}/api/v0#{resource}"
  end

  def wca_client_id
    ENV['WCA_CLIENT_ID']
  end

  def wca_login_url(scopes)
    "#{wca_base_url}/oauth/authorize?response_type=code&client_id=#{wca_client_id}&scope=#{URI.encode(scopes)}&redirect_uri=#{fixed_wca_callback_url}"
  end

  def wca_client_secret
    ENV['WCA_CLIENT_SECRET']
  end

  def fixed_wca_callback_url
    wca_callback_url.sub("localhost", "127.0.0.1")
  end
end