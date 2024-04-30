require 'bundler/setup'

require "sinatra"
require "sinatra/content_for"
require "tilt/erubis" 
require "dotenv/load"

require_relative "session_persistence"
require_relative "database_persistence"
require_relative "view_helpers"
require_relative "helpers"

configure do
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET']
  set :sessions, :expire_after => 604800 #one week  
  set :erb, :escape_html => true
  set :environment, :development
end

configure(:development) do
  require "sinatra/reloader"
  also_reload "database_persistence.rb"
  also_reload "session_persistence.rb"
  also_reload "view_helpers.rb"
  also_reload "helpers.rb"
end

before do
  @session_persistence = SessionPersistence.new(session)
  @db_persistence = DatabasePersistence.new(logger)
end

before '/birds*' do
  require_signed_in_user
end

after do
  @db_persistence.disconnect_db
end

# not found page
not_found do
  require_signed_in_user
  validate_no_params

  msg = "Page not found."
  @session_persistence.add_message(msg)

  status 404
  erb :not_found_page
end

# view sign in page
get "/users/signin" do
  validate_no_params

  erb :signin
end

# signin user
post "/users/signin" do
  keys = [:username, :password]

  validate_params(params, keys)

  username = params[:username]
  password = params[:password]

  error = signin_error(username, password)
  if error
    msg = error
    @session_persistence.add_message(msg)

    status 422
    erb :signin
  else
    if valid_signin?(username, password)

      user_id = @db_persistence.retrieve_user_id(username).to_i
      @session_persistence.add_user_id(user_id)
  
      msg = "Welcome #{username}, you now have access to your bird life list."
      @session_persistence.add_message(msg)

      redirect return_to_origin || "/"
    else
      msg = "Invalid credentials, please try again."
      @session_persistence.add_message(msg)

      status 422
      erb :signin
    end
  end
end

# view register page
get "/users/register" do
  validate_no_params

  msg = "Please create an account to get started."
  @session_persistence.add_message(msg)

  erb :register
end

# register new user
post "/users/register" do
  keys = [:username, :password]

  validate_params(params, keys)

  username = params[:username]
  password = params[:password]

  error = register_error(username, password)

  if error
    msg = error
    @session_persistence.add_message(msg)

    status 422
    erb :register
  else
    @db_persistence.create_account(username, password)
    msg = "Account created, you can now sign in."
    @session_persistence.add_message(msg)

    redirect "/users/signin"
  end
end

# signin and set origin required for all routes below

# landing page
get "/" do
  require_signed_in_user
  validate_no_params

  redirect "/birds"
end

# signout user
post "/users/signout" do
  require_signed_in_user
  validate_no_params

  @session_persistence.sign_out

  msg = "You were successfully signed out."
  @session_persistence.add_message(msg)

  redirect "users/signin"
end

# view all of the birds
get "/birds" do
  params[:page] = 1 if params[:page].nil? 

  keys = [:page]

  @page = params[:page].to_i
  @birds = @db_persistence.all_birds(session[:user_id])
  @size = @birds.size
  @max_elements = 6
  @pages = calculate_pages(@size, @max_elements)

  if !params_valid?(params, keys)
    msg = "Invalid action."
    @session_persistence.add_message(msg)

    status 400
    erb :birds
  elsif !page_valid?(@page, @pages)
    msg = "Invalid page number."
    @session_persistence.add_message(msg)

    status 404
  else

    erb :birds
  end
end

# view a new bird form
get "/birds/new" do
  validate_no_params

  erb :new_bird
end

# create a new bird
post "/birds/new" do
  keys = [:common_name, :scientific_name]
  validate_params(params, keys)

  user_id = session[:user_id]
  common_name = sanitize_common_name(params[:common_name])
  scientific_name = sanitize_scientific_name(params[:scientific_name])


  error = name_error(user_id, common_name, scientific_name)
  if error
    msg = error
    @session_persistence.add_message(msg)

    status 422
    erb :new_bird
  else
    @db_persistence.add_species(user_id, common_name, scientific_name)
    msg = "The species has been added, you can now add an observation."
    @session_persistence.add_message(msg)

    redirect "/birds"
  end
end

# view a bird
get "/birds/:bird_id" do
  params[:page] = 1 if params[:page].nil? 
  keys = [:bird_id, :page]

  user_id = session[:user_id]
  @bird_id = params[:bird_id].to_i
  if !id_valid?(@bird_id, params[:bird_id])

    status 404
  else
    @bird = load_bird(@bird_id, user_id)

    if !@bird

      status 404
    elsif !params_valid?(params, keys)
      @max_elements = 6
      @size = @bird[:total_observations]
      @pages = calculate_pages(@size, @max_elements)
      @page = params[:page].to_i
      @offset = @max_elements * (@page - 1)

      @observations = @db_persistence.current_observations(@bird_id, user_id, @offset, @max_elements)

      msg = "Invalid action."
      @session_persistence.add_message(msg)

      status 400
      erb :bird
    elsif !page_valid?(@page, @pages) 

      status 404
    else
      @max_elements = 6
      @size = @bird[:total_observations]
      @pages = calculate_pages(@size, @max_elements)
      @page = params[:page].to_i
      @offset = @max_elements * (@page - 1)
      
      @observations = @db_persistence.current_observations(@bird_id, user_id, @offset, @max_elements)

      erb :bird
    end
  end
end

# view all of the birds
get "/birds" do
  params[:page] = 1 if params[:page].nil? 

  keys = [:page]

  @page = params[:page].to_i
  @birds = @db_persistence.all_birds(session[:user_id])
  @size = @birds.size
  @max_elements = 6
  @pages = calculate_pages(@size, @max_elements)

  if !params_valid?(params, keys)
    msg = "Invalid action."
    @session_persistence.add_message(msg)

    status 400
    erb :birds
  elsif !page_valid?(@page, @pages)

    status 404
  else

    erb :birds
  end
end

# view edit bird page
get "/birds/:bird_id/edit" do
  keys = [:bird_id]
  validate_params(params, keys)

  user_id = session[:user_id]
  bird_id = params[:bird_id].to_i

  if !id_valid?(bird_id, params[:bird_id])

    status 404
  else
    @bird = load_bird(bird_id, user_id)

    if !@bird

      status 404
    else
      erb :edit_bird
    end
  end
end

# updates a bird
post "/birds/:bird_id" do
  keys = [:common_name, :scientific_name, :bird_id]
  validate_params(params, keys)

  user_id = session[:user_id]

  common_name = sanitize_common_name(params[:common_name])
  scientific_name = sanitize_scientific_name(params[:scientific_name])
  bird_id = params[:bird_id].to_i

  if !id_valid?(bird_id, params[:bird_id])

    status 404
  else

    @bird = load_bird(bird_id, user_id)

    error = edit_name_error(user_id, bird_id, common_name, scientific_name)

    if error
      msg = error
      @session_persistence.add_message(msg)
      status 422
      erb :edit_bird
    elsif !@bird

      status 404
    else
      @db_persistence.update_bird(user_id, bird_id, common_name, scientific_name)
      msg = "The species has been updated."
      @session_persistence.add_message(msg)
      redirect "/birds/#{bird_id}"
    end
  end
end

# delete a species from list
post "/birds/:bird_id/delete" do
  keys = [:bird_id]
  validate_params(params, keys)

  user_id = session[:user_id]
  bird_id = params[:bird_id].to_i
  if !id_valid?(bird_id, params[:bird_id])

    msg = "The specified species is not valid."
    @session_persistence.add_message(msg)

    status 404
  else
    @db_persistence.delete_bird(bird_id, user_id)

    msg = "The species has been deleted from your list."
    @session_persistence.add_message(msg)

    redirect "/birds"
  end
end

# view observation
get "/birds/:bird_id/observations/:observation_id" do
  keys = [:bird_id, :observation_id]
  validate_params(params, keys)


  user_id = session[:user_id]
  @bird_id = params[:bird_id].to_i
  @observation_id = params[:observation_id].to_i

  if !id_valid?(@bird_id, params[:bird_id])

    status 404
  else
    @bird = load_bird(@bird_id, user_id)
 
    if !@bird

      status 404
    else

      if !id_valid?(@observation_id, params[:observation_id])
    
        status 404
      else
        @observation = load_observation(@observation_id, @bird_id, user_id)
        if !@observation

          status 404
        else
          erb :observation
        end
      end
    end
  end
end

# view new observation page
get "/birds/:bird_id/new_observation" do
  
  keys = [:bird_id]
  validate_params(params, keys)

  bird_id = params[:bird_id].to_i

  if !id_valid?(bird_id, params[:bird_id])

    msg = "The specified species is not valid."
    @session_persistence.add_message(msg)

    status 404
  else
    erb :new_observation
  end
end

# create new observation
post "/birds/:bird_id/new_observation" do
  keys = [
  :bird_id,
  :date,
  :location,
  :quantity,
  :time,
  :habitat,
  :weather,
  :behavior,
  :song_pattern,
  :additional_notes
  ]
  validate_params(params, keys)

  user_id = session[:user_id]
  bird_id = params[:bird_id].to_i

  date = params[:date]
  location = sanitize_observation_input(params[:location])
  quantity = sanitize_observation_input(params[:quantity])
  time = sanitize_observation_input(params[:time])
  habitat = sanitize_observation_input(params[:habitat])
  weather = sanitize_observation_input(params[:weather])
  behavior = sanitize_observation_input(params[:behavior])
  song_pattern = sanitize_observation_input(params[:song_pattern])
  additional_notes = sanitize_observation_input(params[:additional_notes])

  error = observation_input_error(date, location, quantity, time, habitat, weather, behavior, song_pattern, additional_notes)

  if !id_valid?(bird_id, params[:bird_id])

    msg = "The specified species is not valid."
    @session_persistence.add_message(msg)

    status 404
  else
    @bird = load_bird(bird_id, user_id)

    if !@bird
      msg = "The specified species was not found."
      @session_persistence.add_message(msg)

      status 404
    else
      if error
        msg = error
        @session_persistence.add_message(msg)

        status 422
        erb :new_observation
      else
        @db_persistence.add_observation(user_id, bird_id, date, location, time, habitat, weather, behavior, quantity, song_pattern, additional_notes)
        msg = "The observation has been added."
        @session_persistence.add_message(msg)

        redirect "/birds/#{bird_id}"
      end
    end
  end
end

# view edit observation
get "/birds/:bird_id/observations/:observation_id/edit" do  
  keys = [:bird_id, :observation_id]
  validate_params(params, keys)

  user_id = session[:user_id]
  bird_id = params[:bird_id].to_i
  observation_id = params[:observation_id].to_i
  if !id_valid?(bird_id, params[:bird_id])

    msg = "The specified species is not valid."
    @session_persistence.add_message(msg)

    status 404
  else
    @bird = load_bird(bird_id, user_id)

    if !@bird
      msg = "The specified species was not found."
      @session_persistence.add_message(msg)

      erb :not_found_page
    else
      if !id_valid?(observation_id, params[:observation_id])

        msg = "The specified observation is not valid."
        @session_persistence.add_message(msg)
    
        status 404
      else
        @observation = load_observation(observation_id, bird_id, user_id)

        if !@observation
          msg = "The specified observation was not found."
          @session_persistence.add_message(msg)
    
          status 404
        else
          erb :edit_observation
        end
      end
    end
  end
end

# update observation
post "/birds/:bird_id/observations/:observation_id" do
  keys = [
    :bird_id,
    :observation_id,
    :date,
    :location,
    :quantity,
    :time,
    :habitat,
    :weather,
    :behavior,
    :song_pattern,
    :additional_notes
    ]
  validate_params(params, keys)

  user_id = session[:user_id]
  bird_id = params[:bird_id].to_i
  observation_id = params[:observation_id].to_i

  if !id_valid?(bird_id, params[:bird_id])

    msg = "The specified species is not valid."
    @session_persistence.add_message(msg)

    status 404
  else
    @bird = load_bird(bird_id, user_id)
    if !@bird
      msg = "The specified species was not found."
      @session_persistence.add_message(msg)

      status 404
    else
      if !id_valid?(observation_id, params[:observation_id])

        msg = "The specified observation is not valid."
        @session_persistence.add_message(msg)
    
        status 404
      else
        @observation = load_observation(observation_id, bird_id, user_id)

        if !@observation
          msg = "The specified observation was not found."
          @session_persistence.add_message(msg)

          erb :not_found_page
        else
          date = params[:date]
          location = sanitize_observation_input(params[:location])
          quantity = sanitize_observation_input(params[:quantity])
          time = sanitize_observation_input(params[:time])
          habitat = sanitize_observation_input(params[:habitat])
          weather = sanitize_observation_input(params[:weather])
          behavior = sanitize_observation_input(params[:behavior])
          song_pattern = sanitize_observation_input(params[:song_pattern])
          additional_notes = sanitize_observation_input(params[:additional_notes])

          error = observation_input_error(date, location, quantity, time, habitat, weather, behavior, song_pattern, additional_notes)

          if error
            msg = error
            @session_persistence.add_message(msg)
          
            status 422
            erb :edit_observation
          else
            @db_persistence.update_observation(observation_id, user_id, bird_id, date, location, time, habitat, weather, behavior, quantity, song_pattern, additional_notes)
          
            msg = "The observation has been updated."
            @session_persistence.add_message(msg)
          
            redirect "/birds/#{bird_id}/observations/#{observation_id}"
          end
        end
      end
    end
  end
end

# delete observation 
post "/birds/:bird_id/observations/:observation_id/delete" do
  keys = [:bird_id, :observation_id]
  validate_params(params, keys)

  user_id = session[:user_id]
  bird_id = params[:bird_id].to_i
  observation_id = params[:observation_id].to_i

  if !id_valid?(bird_id, params[:bird_id])

    status 404
  else
    @bird = load_bird(bird_id, user_id)
    if !@bird

    status 404
    else
      if !id_valid?(observation_id, params[:observation_id])
    
        status 404
      else
        @observation = load_observation(observation_id, bird_id, user_id)

        if !@observation

          status 404
        else
          @db_persistence.delete_observation(observation_id, bird_id, user_id)

          msg = "The observation has been deleted."
          @session_persistence.add_message(msg)

          redirect "/birds/#{bird_id}"
        end
      end
    end
  end
end
