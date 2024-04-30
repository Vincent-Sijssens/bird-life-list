require "pg"
require "bcrypt"

class DatabasePersistence
  def initialize(logger)
    @db = if Sinatra::Base.production?
          PG.connect(ENV['DATABASE_URL'])
          else
          PG.connect(dbname: "bird_life_list")
          end
    @logger = logger
  end

  def disconnect_db
    @db.close
  end

  def user_exists?(username)
    sql = <<~SQL
            SELECT username
            FROM users
            WHERE username = $1
            LIMIT 1
          SQL

    result = query(sql, username)

    result.first
  end

  def pw_corresponds?(username, password)
    sql = <<~SQL
            SELECT password_hash
            FROM users
            WHERE username = $1
            LIMIT 1
          SQL

    result = query(sql, username)

    tuple = result.first

    bcrypt_password = BCrypt::Password.new(tuple["password_hash"])
    bcrypt_password == password
  end

  def retrieve_user_id(username)
    sql = <<~SQL
            SELECT id
            FROM users
            WHERE username = $1
            LIMIT 1
          SQL

    result = query(sql, username)
      
    tuple = result.first

    tuple["id"]
  end

  def create_account(username, password)
    hashed_password = BCrypt::Password.create(password)

    sql = <<~SQL
          INSERT INTO users (username, password_hash)
          VALUES ($1, $2);
          SQL

    query(sql, username, hashed_password)
  end

  def all_birds(id)
    sql = <<~SQL
            SELECT birds.id, birds.common_name, birds.scientific_name,
            count(observations.id) AS total_observations
            FROM birds
            LEFT JOIN observations
             ON birds.id = observations.bird_id
            WHERE birds.user_id = $1
            GROUP BY birds.id
          SQL
    result = query(sql, id)

    result.map do |tuple|
      bird_tuple_to_hash(tuple)
    end
  end

  def species_exists?(user_id, name)
        sql = <<~SQL
            SELECT birds.id
            FROM birds
            WHERE user_id = $1 AND (common_name = $2 OR scientific_name = $2)
            LIMIT 1
            SQL

    result = query(sql, user_id, name)

    result.first
  end

  def edited_species_exists?(user_id, bird_id, name)
    sql = <<~SQL
          SELECT birds.id
          FROM birds
          WHERE user_id = $1 AND id != $2 AND (common_name = $3 OR scientific_name = $3)
          LIMIT 1
          SQL

    result = query(sql, user_id, bird_id, name)

    values = result.values

    result.first
  end

  def add_species (user_id, common_name, scientific_name)
    sql = <<~SQL
          INSERT INTO birds (user_id, common_name, scientific_name)
          VALUES ($1, $2, $3);
          SQL

    query(sql, user_id, common_name, scientific_name)
  end

  def update_bird (user_id, bird_id, common_name, scientific_name)
    sql = <<~SQL
            UPDATE birds
            SET common_name = $3, scientific_name = $4
            WHERE user_id = $1 AND id = $2
          SQL

    query(sql, user_id, bird_id, common_name, scientific_name)
  end

  def find_bird(bird_id, user_id)
  sql = <<~SQL
        SELECT birds.id, birds.common_name, birds.scientific_name,
        count(observations.id) AS total_observations
        FROM birds
        LEFT JOIN observations
         ON birds.id = observations.bird_id
         WHERE birds.id = $1 AND birds.user_id = $2
        GROUP BY birds.id
        LIMIT 1
        SQL

    result = query(sql, bird_id, user_id)

    tuple = result.first

    if tuple
      bird_tuple_to_hash(tuple)
    end
  end

  def delete_bird(bird_id, user_id)
    query("DELETE FROM observations WHERE bird_id = $1 AND user_id = $2", bird_id, user_id)
    query("DELETE FROM birds WHERE id = $1 AND user_id = $2", bird_id, user_id)      
  end

  def find_observation(observation_id, bird_id, user_id)
    sql = <<~SQL
    SELECT observations.date,
           observations.time,
           observations.location,
           observations.habitat,
           observations.weather,
           observations.behavior,
           observations.quantity,
           observations.song_pattern,
           observations.additional_notes
    FROM observations
    JOIN birds
     ON observations.bird_id = birds.id 
    WHERE observations.id = $1 AND birds.id = $2 AND birds.user_id = $3
    GROUP BY observations.id
    LIMIT 1
    SQL

  result = query(sql, observation_id, bird_id, user_id)

  tuple = result.first
  
    if tuple
      { 
        date: tuple["date"], 
        quantity: tuple["quantity"],
        location: tuple["location"],
        time: tuple["time"],
        habitat: tuple["habitat"],
        weather: tuple["weather"],
        behavior: tuple["behavior"],
        song_pattern: tuple["song_pattern"],
        additional_notes: tuple["additional_notes"]
      }
    end
  end

  def current_observations(bird_id, user_id, offset, max_elements)
    sql = <<~SQL
          SELECT id, "date", "location", quantity FROM observations 
          WHERE bird_id = $1 AND user_id = $2
          ORDER BY date, location
          OFFSET $3
          LIMIT $4
          SQL

    observations_result = query(sql, bird_id, user_id, offset, max_elements)

    observations_result.map do |tuple|
      { id: tuple["id"].to_i, 
        date: tuple["date"], 
        location: tuple["location"],
        quantity: tuple["quantity"]
      }
    end
  end

  def add_observation(user_id, bird_id, date, location, time, habitat, weather, behavior, quantity, song_pattern, additional_notes)
    sql = <<~SQL
    INSERT INTO observations (user_id, bird_id, "date", "location", "time", habitat, weather, behavior, quantity, song_pattern, additional_notes)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
    SQL

    query(sql, user_id, bird_id, date, location, time, habitat, weather, behavior, quantity, song_pattern, additional_notes)
  end

  def delete_observation(observation_id, bird_id, user_id)
    sql = <<~SQL
          DELETE FROM observations 
          WHERE id = $1 AND bird_id = $2 AND user_id = $3
          SQL

    query(sql, observation_id, bird_id, user_id)    
  end

  def update_observation(observation_id, user_id, bird_id, date, location, time, habitat, weather, behavior, quantity, song_pattern, additional_notes)
    sql = <<~SQL
          UPDATE observations
          SET "date" = $4,
              "location" = $5, 
              "time" = $6,
              habitat = $7,
              weather = $8,
              behavior = $9,
              quantity = $10,
              song_pattern = $11, 
              additional_notes = $12
              WHERE id = $1 AND user_id = $2 AND bird_id = $3
          SQL

    query(sql, observation_id, user_id, bird_id, date, location, time, habitat, weather, behavior, quantity, song_pattern, additional_notes)
  end

  private

  def query(statement, *parameters)
    @logger.info "#{statement}: #{parameters}"
    @db.exec_params(statement, parameters)
  end

  def bird_tuple_to_hash(tuple)
    {
      id: tuple["id"].to_i,
      common_name: tuple["common_name"],
      scientific_name: tuple["scientific_name"],
      total_observations: tuple["total_observations"].to_i
    }
  end
end
