class AuthenticationsController < UserBaseController
  def index
  end

  def create
    session[:service_type] = params[:service_type]
    case session[:service_type]
    when 'facebook'
      facebook = Settings.web_services.facebook
      fbauth = FbGraph::Auth.new(facebook.access_token, facebook.access_secret)
      fbauth.client.redirect_uri = facebook.redirect_uri
      redirect_to fbauth.client.authorization_uri(:scope => [:email, :publish_stream, :offline_access])
    when 'twitter'
      twitter = Settings.web_services.twitter
      consumer = OAuth::Consumer.new(twitter.access_token, twitter.access_secret, site: 'http://twitter.com')
      request_token = consumer.get_request_token(oauth_callback: twitter.redirect_uri)
      session[:request_token]        = request_token.token
      session[:request_token_secret] = request_token.secret
      redirect_to request_token.authorize_url
    end
  end

  def callback
    case session[:service_type]
    when 'facebook'
      fbauth.client.authorization_code = params[:code]
      access_token = fbauth.client.access_token!(:client_auth_body)
      me = FbGraph::User.me(access_token).fetch
      current_user.authentications.create(service_type: 'facebook', access_token: access_token.to_s, uid: me.identifier)
      redirect_to authentications_path
    when 'twitter'
      twitter = Settings.web_services.twitter
      consumer = OAuth::Consumer.new(twitter.access_token, twitter.access_secret, site: 'http://twitter.com')
      request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
      access_token = request_token.get_access_token({}, oauth_token: params[:oauth_token], oauth_verifier: params[:oauth_verifier])
      logger.debug(access_token.inspect)
      current_user.authentications.create(service_type: 'twitter', access_token: access_token.token, access_secret: access_token.secret, uid: access_token.params[:user_id])
      redirect_to authentications_path
    end
  end

  def destroy
    authentication = current_user.authentications.find(params[:id])
    authentication.destroy
    redirect_to :back
  end

  private
  def fbauth
    return @fbauth if @fbauth
    facebook = Settings.web_services.facebook
    @fbauth = FbGraph::Auth.new(facebook.access_token, facebook.access_secret)
    @fbauth.client.redirect_uri = facebook.redirect_uri
    @fbauth
  end
end
