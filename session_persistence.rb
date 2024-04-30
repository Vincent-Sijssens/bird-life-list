class SessionPersistence
  def initialize(session)
    @session = session
  end

  def user_signed_in?
    @session.key?(:user_id)
  end

  def add_user_id(id)
    @session[:user_id] = id
  end

  def retrieve_user_id
    @session[:user_id]
  end

  def sign_out
    @session.clear
  end

  def delete_key(key)
    @session.delete(key)
  end

  def message
    @session[:message]
  end

  def add_message(msg)
    @session[:message] = msg
  end

  def add_return(path, params)
    p params = params.reject{ |k,v| k == "splat"}
    if params.empty?
      @session[:return_to] = path
    else
      query_string = params.to_a.map{ |pair| pair.join("=")}.join("&")
      @session[:return_to] = path + "?#{query_string}" 
    end
  end
end
