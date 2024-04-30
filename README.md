# BirdLifeList
## Introduction
Hello fellow birder, welcome to the BirdLifeList App.

The app will allow you to save a lifetime of birding observations.

Every time you observe a species of bird you haven't observed before you can add it to your list.

When you've added a new species, you can add your observation details by clicking on the species name and the `add new observation` link. Here you can add the following details:

- date (required)
- location (required)
(ex: Central Park, New York)
- number of individuals observed (required)
(ex: 1, two, a few hundred)
- time of day
(ex.: 10AM, afternoon)
- habitat
(ex: urban park)
- weather
(ex.:cloud, rainy, sunny)
- behavior
(ex.: feeding, nesting, in flight)
- song pattern
(ex. pew pew pew pew)
- additional notes
(ex.: near a river bank)

Whenever you observe the same species again, you can just click on the species in question again and add another observation. Now you can keep track of all the birds you've ever observed, and this for the rest of your life!

You can always edit any bird species by clicking on its name and going to the `edit species` link. From here you can also delete the species from the list.

To edit an observation, just click on the observation in question and go to the `edit observation` link. From here, you can also delete it if you wish.

Happy birdwatching!

## Getting started
To begin verify that you have PostgreSQL installed. The version used to develop the app is `postgres (PostgreSQL) 14.6 (Homebrew)`, make sure you have the same version installed.

Now make sure that all the unzipped files are stored in the same project folder.

In the command line, go to the project folder by using the `cd` command. Use the command `ruby -v` to verify the current version of Ruby. Make sure you have version 3.1.2 of Ruby installed and that it's the current version.

From here run `bundle install`. This will install all gems needed for the project. (If you haven't installed bundler, run `gem install bundler` first). This also includes the `puma` server used on this project.

Now we will set up the database on our system. To do this run `createdb bird_life_list` (run `dropdb bird_life_list` if you alreday have a db named like this). Still from the project folder, run `psql -d bird_life_list < bird_life_list.dump.sql`. The schema and seed data for the app are now set up.

Now, from the project folder, run `bundle exec ruby bird_life_list.rb`. This will start the server running the app.

Now open up your browser and type in the URL-addres `localhost:4567`. For this project, Firefox Browser version 113.0.2 (64-bit) was used, make sure you are running the same version.

From the web page you can now either log in with the username `admin` and password `secret` to use the bird life list app with some seeded data, or you can create your own account and log in to create you bird life list from scratch.

## Assumptions and decisions

### Database design
- The database `bird_life_list` contains three tables: `users`, `birds` and `observations`. 
- `users` has a one-to-many relationship with `birds`
- `birds` has a one-to-many relationship with `observations`
- `users` has a one-to-many relationship with `observations`
- the relationship between `users` and `observations` is not essential to the database, however, since the app is using the `user_id` for authentication. I decided to add it to every query as an additional validation, making unauthorized data-access harder.
- inside the `birds` table `common name` and `scientific name` must be unique for every user. i.e a single user can have no duplicate species on their list but multiple users can have the same species on their list. This is achieved through the `UNIQUE (user_id, common_name)` 
`UNIQUE (user_id, scientific_name)`conditionals.
- Each observation must at least contain a `date`, `location` and `quantity` (of observed species) to be valid. 
- Observations can be duplicate, since it is plausible that two different observations can contain these same three attributes.
- For security reasons passwords are not stored directly in the `users` table, istead we use password hashes.

### Schema and seed data
- The schema for `users`, `birds` and `observations`, all seed-data for `users` and `birds` and seven lines of `observations` data was fed to Chat-GPT with a prompt to create an additional 100 random observations in order to create a bigger set of observations for the seed-data.
- The common and scientific names inside the `birds` table were found on the following website: https://checklist.americanornithology.org/
- a `schema.sql` and `seed_data.sql` file are provided for reference only, since the `bird_life_list.dump.sql` file is all that is needed to set up the database tables.

### Application design
- The application code is organized into five different files; `bird_life_list.rb`, `helpers.rb`, `view_helpers.rb`, `database_persistence.rb`, `session_persistence.rb`.
- `bird_life_list.rb` takes care of all configuration and routing logic.
- `helpers.rb` contains all helper methods that deal with the internal business logic.
- `view_helpers.rb` contains all helper methods involved in rendering to the page.
- `database_persistence.rb` contains all database interaction logic, i.e all communications with externally stored data.
- `session_persistence.rb` contains all session interaction logic, i.e. all communications with data stored inside of a session, which we use to create a stateful experience on an inherently stateless HTTP protocol.
- This architecture follows the adapter-pattern logic, i.e. we define an API that we use to interact with the data that is stored for the application. If the data stores change, we just need to define new classes and define the methods inside of them without having to change our application logic.

### Pagination
- Pagination is implemented for both birds and observations. They are implemented differently however and this has to do with how they are ordered. 
- The birds are ordered by their common name. A common name can be made up of multiple words (ex.: Rook, Rock Pigeon, Common Wood Pigeon). Therefore the names should be ordered by the last word first, and then by the first word ,so that all sub-species are alphabetially grouped together. 
- This sorting logic was easier to implement inside of the application logic than inside of a query. The `sort_birds` method inside of `view_helpers.rb` takes care of the sorting and grouping. The disadvantage of this approach is that for each page all the birds need to be queried first.
- The observations are sorted by `date` and then `location`, since this is easily done inside of the query, we can just implement a `LIMIT` and `OFFSET` in the query making this approach more efficient in resources.

### Query optimization
- A `LIMIT` is implemented inside each query where possible, to reduce overhead
- Observations are counted inside of the query, so no additional queries are performed to access these child elements, thereby avoiding N+1 queries. 

### Authentication
A `require_signed_in_user` method ensures the user is signed in before any user-specific Get or POST requests can be processed. Registering and signing in are the only functionalities that do not require this validation. A `session[:user_id]` is set after signing in, the existence of this key is validated on each relevant route. The session is cleared when logging out, thus removing the `session[:user_id]`. All passwords are hashed through the BCrypt gem. 

### Redirect after signing in
A `SessionPersistence#add_return` method saves the `request.path_info` to the session. The query string is also reconstructed inside this method so that we land on the originally requested page number after signing in. Inside of the `users/signin` POST route we redirect to a `return_to_origin` method, which returns the previously saved and now deleted session value.

### Query-string validation
- On each route valid keys for query parameters are defined. When invalid keys are sent, a 400 status response is sent back with an `Invalid action.` message. 
- When the keys are valid, the values are then validated within each route where necessary.

### URL validation
- A user needs to be signed in before being notified of an invalid URL. The same redirect after signin logic is implemented in the `not_found` route, a dedicated `not_found_page.erb` is then rendered. I decided against redirecting, so the faulty URL remains visible to the user inside the web-browser.

### Session persistence
In order for our session to persist even after closing the browser, I've set, inside of the `configuration` block, its expiration to one week. This means the `rack.session` cookie remains available to the browser, which in turn allows us to stay logged in after reopening the browser, until we delete the cookie or until it expires.

### Development or production?
Since we are not deploying to the web, but consulting the app on our local machine, the application environment is set to `development`. If our website was live, this would need to be changed to `production`.

### Session secret
I've followed the Sinatra documentation recommendations for session secret security and saved it inside of a `.env` file which is included in the zip file. The `dotenv` gem is used to retrieve this file.

### Security considerations
A main feature that is missing, since the application is not deployed on the web, is the use of HTTPS. When deployed to the web this should be implemented so that intercepted HTTP requests and responses are (almost) unusable.
