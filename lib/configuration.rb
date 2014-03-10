class Configuration
  def initialize
    if production?
      raise ArgumentError.new "Must provide Github API key as GITHUB_API_KEY environment variable" unless @github_api_key = ENV['GITHUB_API_KEY']
      raise ArgumentError.new "Must provide Github API secret as GITHUB_SECRET_KEY environment variable" unless @github_secret_key = ENV['GITHUB_SECRET_KEY']
     end
  end

  def omniauth_providers
    providers = []

    if production?
      providers << (OmniAuthProviderConfig.new :github, [@github_api_key, @github_secret_key])
    else
      providers << (OmniAuthProviderConfig.new :developer, nil)
    end

    providers
  end

  private
  def production?
    ENV['RACK_ENV'] == 'production'
  end
end

class OmniAuthProviderConfig
  attr_reader :id, :parameters

  def initialize id, parameters
    @id = id
    @parameters = parameters || []
  end
end