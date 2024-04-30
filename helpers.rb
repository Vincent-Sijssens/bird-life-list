def validate_no_params
  unless params.empty?
    msg = "Invalid action."
    @session_persistence.add_message(msg)
    
    status 400
  end
end

def validate_params(params, keys)
  unless params.empty? || keys.sort == params.keys.map(&:to_sym).sort
    msg = "Invalid action."
    @session_persistence.add_message(msg)

    status 400
  end
end

def params_valid?(params, keys)
  params.empty? || keys.sort == params.keys.map(&:to_sym).sort
end

def page_valid?(page, pages)
  params[:page] == 1 || (pages.include?(page) && page.to_s == params[:page])
end

def require_signed_in_user  
  unless @session_persistence.user_signed_in?

    set_origin

    session[:message] = "Please sign in to access your bird life list."

    redirect "users/signin"
  end
end

def verify_query_strings
  unless params.size <= 2 && params.has_key?(:page)
    status 400
  end
end

def set_origin
  path = request.path_info

  @session_persistence.add_return(path, params)
end

def return_to_origin
  @session_persistence.delete_key(:return_to)
end

def valid_signin?(username, password)
  @db_persistence.user_exists?(username) && @db_persistence.pw_corresponds?(username, password)
end

def id_valid?(id, params_id)
  id.to_s == params_id
end

def load_bird(bird_id, user_id)
  bird = @db_persistence.find_bird(bird_id, user_id)
  if bird
    bird
  else
    false
  end
end

def load_observation(observation_id, bird_id, user_id)
  observation = @db_persistence.find_observation(observation_id, bird_id, user_id)
  if observation
    observation
  else
    false
  end
end

def name_error(user_id, common_name, scientific_name)
  errors = { 
    common_name_error: invalid_name(user_id, common_name, 50),
    scientific_name_error: invalid_name(user_id, scientific_name, 50)
  }

  name_msg(errors)
end

def edit_name_error(user_id, bird_id, common_name, scientific_name)
  errors = { 
    common_name_error: edit_invalid_name(user_id, bird_id, common_name, 50),
    scientific_name_error: edit_invalid_name(user_id, bird_id, scientific_name, 50)
  }

  name_msg(errors)
end

def sanitize_common_name(name)
  name.strip.split.map(&:capitalize).join(' ')
end

def sanitize_scientific_name(name)
  name.strip.capitalize.split.join(' ')
end

def signin_error(username, password)
  errors = {
    username_error: si_invalid_username(username, 50),
    password_error: si_invalid_pw(password)
  }

  username_pw_msg(errors)
end

def register_error(username, password)
  
  errors = {
    username_error: invalid_username(username, 50),
    password_error: invalid_pw(password)
  }

  username_pw_msg(errors)
end

def sanitize_observation_input(input)
  input.strip.split.join(' ')
end

def observation_input_error(date, location, quantity, time, habitat, weather, behavior,  song_pattern, additional_notes)
  errors = {
    date_error: invalid_date(date),
    location_error: invalid_required(location, 100),
    quantity_error: invalid_required(quantity, 100),
    time_error: invalid_optional(time, 100),
    habitat_error: invalid_optional(habitat, 100),
    weather_error: invalid_optional(weather, 100),
    behavior_error: invalid_optional(behavior, 100),
    song_pattern_error: invalid_optional(song_pattern, 100),
    additional_notes_error: invalid_optional(additional_notes, 200)
  }

  observation_msg(errors)
end

def calculate_pages(size, max_elements)
  if size == 0
    [1]
  else
    last_page = (size / max_elements.to_f).ceil
    (1..last_page).to_a
  end
end

private

def invalid_name(user_id, name, max_size)
  if name.size > max_size
    "must be smaller than #{max_size} characters"
  elsif name.size < 1
    "cannot be empty"
  elsif name.match(/[^a-zA-z\-\' ]/)
    "contains invalid characters"
  elsif @db_persistence.species_exists?(user_id, name)
    "is already on your list"
  else
    false
  end
end

def edit_invalid_name(user_id, bird_id, name, max_size)
  if name.size > max_size
    "must be smaller than #{max_size} characters"
  elsif name.size < 1
    "cannot be empty"
  elsif name.match(/[^a-zA-z\-\' ]/)
    "contains invalid characters"
  elsif @db_persistence.edited_species_exists?(user_id, bird_id, name)
    "is already on your list"
  else
    false
  end
end

def name_msg(errors)
  errors.select!{|k, v| v}

  if !errors.empty?
    errors.map do |error, msg|
      case error
      when :common_name_error
        "common name " + msg
      when :scientific_name_error
        "scientific name " + msg
      end
    end.join(", ").capitalize + "."
  else
    false
  end
end

def si_invalid_username(name, max_size)
  if name.size < 1
    "cannot be empty"
  else
    false
  end
end

def si_invalid_pw(pw)
  if pw.size < 1
    "cannot be empty"
  else
    false
  end
end

def invalid_username(name, max_size)
  if name.size > max_size
    "must be smaller than #{max_size} characters"
  elsif name.size < 1
    "cannot be empty"
  elsif @db_persistence.user_exists?(name)
    "username is already taken"
  else
    false
  end
end

def invalid_pw(pw)
  if pw.size < 1
    "cannot be empty"
  else
    false
  end
end

def username_pw_msg(errors)
  errors.select!{|k, v| v}

  if !errors.empty?
    errors.map do |error, msg|
      case error
      when :username_error
        "username " + msg
      when :password_error
        "password " + msg
      end
    end.join(", ").capitalize + "."
  else
    false
  end
end

def invalid_date(date)
  if date == ""
    "cannot be empty"
  elsif date > '2200-01-01'
    "cannot follow after 2200-01-01"
  elsif date < '1900-01-01'
    "cannot precede 1900-01-01"
  else
    false
  end
end

def invalid_required(input, max_size)
  if input.size > max_size
    "must be smaller than #{max_size} characters"
  elsif input.size < 1
    "cannot be empty"
  else
    false
  end
end

def invalid_optional(input, max_size)
  if input.size > max_size
    "must be smaller than #{max_size} characters"
  else
    false
  end
end

def observation_msg(errors)
  errors.select!{|k, v| v}
  
  if !errors.empty?
    errors.map do |error, msg|
      case error
      when :date_error 
        "date " + msg
      when :location_error
        "location " + msg
      when :quantity_error
        "quantity " + msg
      when :time_error
        "time " + msg
      when :habitat_error
        "habitat " + msg
      when :weather_error
        "weather " + msg
      when :behavior_error
        "behavior " + msg
      when :song_pattern_error
        "song pattern " + msg
      when :additional_notes_error
        "additional notes " + msg
      end
    end.join(", ").capitalize + "."
  else
    false
  end
end
