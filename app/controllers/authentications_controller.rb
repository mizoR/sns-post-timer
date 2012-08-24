class AuthenticationsController < UserBaseController
  def index
  end

  def create
    facebook = Settings.web_services.facebook
    fbauth = FbGraph::Auth.new(facebook.access_token, facebook.access_secret)
    fbauth.client.redirect_uri = facebook.redirect_uri
    redirect_to fbauth.client.authorization_uri(:scope => [:email, :publish_stream, :offline_access])
  end

  def callback
    facebook = Settings.web_services.facebook
    fbauth = FbGraph::Auth.new(facebook.access_token, facebook.access_secret)
    fbauth.client.redirect_uri = facebook.redirect_uri
    fbauth.client.authorization_code = params[:code]
    access_token = fbauth.client.access_token!(:client_auth_body)
    me = FbGraph::User.me(access_token).fetch
    current_user.authentications.create(service_type: 'facebook', access_token: access_token.to_s, uid: me.identifier)
    redirect_to authentications_path
  end
end
