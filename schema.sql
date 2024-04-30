DROP TABLE IF EXISTS users, birds, observations;

CREATE TABLE users(
  id serial PRIMARY KEY,
  username varchar(50) UNIQUE NOT NULL,
  password_hash varchar(60) NOT NULL
);

CREATE TABLE birds(
id serial PRIMARY KEY,
common_name varchar(50) NOT NULL,
scientific_name varchar(50) NOT NULL,
user_id int NOT NULL,
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE CASCADE,
UNIQUE (user_id, common_name),
UNIQUE (user_id, scientific_name)
);

CREATE TABLE observations(
id serial PRIMARY KEY,
date date NOT NULL,
time varchar(100),
location varchar(100) NOT NULL,
habitat varchar(100),
weather varchar(100),
behavior varchar(100),
quantity varchar(100) NOT NULL,
song_pattern varchar(100),
additional_notes varchar(200),
bird_id int NOT NULL,
user_id int NOT NULL,
FOREIGN KEY (bird_id)
REFERENCES birds(id)
ON DELETE CASCADE,
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE CASCADE
);
