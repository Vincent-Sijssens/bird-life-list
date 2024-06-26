INSERT INTO users(username, password_hash)
VALUES
('admin', '$2a$12$reIBGMSDXWzVBxnSrs2eBemW6EFQ0ykwsXgp1ApJXEByy195kzAYe');

INSERT INTO birds (user_id, common_name, scientific_name)
VALUES 
(1, 'Canada Goose', 'Branta canadensis'),
(1, 'Wood Duck', 'Aix sponsa'),
(1, 'Northern Shoveler', 'Spatula clypeata'),
(1, 'Mallard', 'Anas platyrhynchos'),
(1, 'Common Eider', 'Somateria mollissima'),
(1, 'Marbled Wood-Quail', 'Odontophorus gujanensis'),
(1, 'Wild Turkey', 'Meleagris gallopavo'),
(1, 'Barrow''s Goldeneye', 'Bucephala islandica'),
(1, 'Bearded Wood-Partridge', 'Dendrortyx barbatus'),
(1, 'White-tailed Ptarmigan', 'Lagopus leucura'),
(1, 'Gunnison Sage-Grouse', 'Centrocercus minimus'),
(1, 'Rock Pigeon', 'Columba livia'),
(1, 'Common Wood Pigeon', 'Columba palumbus'),
(1, 'Common Cuckoo', 'Cuculus canorus'),
(1, 'Short-tailed Nighthawk', 'Lurocalis semitorquatus'),
(1, 'Spot-tailed Nightjar', 'Hydropsalis maculicaudus'),
(1, 'Black Swift', 'Cypseloides niger'),
(1, 'Fork-tailed Swift', 'Apus pacificus'),
(1, 'Band-tailed Barbthroat', 'Threnetes ruckeri'),
(1, 'White-crested Coquette', 'Lophornis adorabilis'),
(1, 'Ruby-throated Hummingbird', 'Archilochus colubris'),
(1, 'Spotted Rail', 'Pardirallus maculatus'),
(1, 'Common Crane', 'Grus grus'),
(1, 'Common Ringed Plover', 'Charadrius hiaticula'),
(1, 'Greater Sand-Plover', 'Charadrius leschenaultii'),
(1, 'Stilt Sandpiper', 'Calidris himantopus'),
(1, 'Common Snipe', 'Gallinago gallinago'),
(1, 'Sooty Shearwater', 'Ardenna grisea'),
(1, 'Gray Heron', 'Ardea cinerea'),
(1, 'Osprey', 'Pandion haliaetus'),
(1, 'Cooper''s Hawk', 'Accipiter cooperii'),
(1, 'Bald Eagle', 'Haliaeetus leucocephalus'),
(1, 'Barn Owl', 'Tyto alba'),
(1, 'Red-bellied Woodpecker', 'Melanerpes carolinus'),
(1, 'American Kestrel', 'Falco sparverius'),
(1, 'Blue Jay', 'Cyanocitta cristata'),
(1, 'Rook', 'Corvus frugilegus'),
(1, 'Common Raven', 'Corvus corax'),
(1, 'River Warbler', 'Locustella fluviatilis'),
(1, 'Red-breasted Nuthatch','Sitta canadensis'),
(1, 'European Starling','Sturnus vulgaris'),
(1, 'House Sparrow','Passer domesticus'),
(1, 'American Goldfinch','Spinus tristis')
;

INSERT INTO observations (user_id, "date", "time", "location", habitat, weather, behavior, quantity, song_pattern, additional_notes, bird_id)
VALUES 
(1, '2021-09-09', NULL, 'Montréal, Canada', NULL, NULL, 'in flight', '20 to 30', NULL, NULL, 1),
(1, '2022-05-21', '12:45', 'Grand Teton National Park', NULL, NULL, NULL, '10', NULL, NULL, 1),
(1, '2022-10-03', '12:56', '', NULL, NULL, NULL, '', NULL, NULL, 14),
(1, '2021-08-23', NULL, 'Jaques Cartier National Park, Quebec, Canada', NULL, NULL, NULL, 'one', NULL, NULL, 38),
(1, '2022-04-12', '12:45', 'Central Park, New York', 'urban park', 'cloudy with rain', 'in flight', '5', 'croaaak croaaaak croaaaak', 'attacking a Cooper''s Hawk', 38),
(1, '2023-03-04', '10:23', 'Central Park, New York', 'urban park', 'cloudy', 'in flight', '1', NULL, NULL, 38),
(1, '2021-07-11', '09:45', 'Central Park, New York', 'urban park', 'sunny', 'resting', '2', NULL, NULL, 38),
(1, '2022-11-12', 'mid day', 'Central Park, New York', 'urban park', 'sunny', 'feeding', '3', NULL, NULL, 38),
(1, '2021-07-11', NULL, '', NULL, NULL, NULL, 'a really big flock', NULL, NULL, 42),
(1, '2022-05-08', '06:15', 'Cape May, New Jersey', 'coastal', 'sunny', 'foraging', '2', NULL, 'near the beach', 7),
(1, '2022-06-02', '13:00', 'Everglades National Park', 'wetlands', 'hot and humid', 'perched', '1', 'pew pew pew pew', NULL, 22),
(1, '2023-04-23', '07:30', 'Mount Rainier National Park', 'alpine meadow', 'partly cloudy', 'calling', '2', 'tiptiptip tweedle-dee', 'singing from a tree', 34),
(1, '2021-11-19', '15:30', 'Newport, Rhode Island', 'coastal', 'partly cloudy', 'in flight', '5', 'chirp chirp', NULL, 19),
(1, '2022-03-12', '09:15', 'San Diego, California', 'suburban backyard', 'sunny', 'perched', '1', NULL, 'drinking from a birdbath', 25),
(1, '2022-08-09', '06:00', 'Kodiak Island, Alaska', 'tundra', 'overcast', 'in flight', '15', 'honk honk', 'flying south for the winter', 5),
(1, '2023-01-17', '16:00', 'Lubbock, Texas', 'desert', 'sunny', 'perched', '1', NULL, 'near a cactus', 9),
(1, '2022-04-15', '11:30', 'Portland, Oregon', 'urban park', 'rainy', 'foraging', '2', 'titi-titi-titi-titi-titi-titi', 'eating seeds from a feeder', 26),
(1, '2023-02-11', '07:45', 'Yellowstone National Park', 'forest', 'snowy', 'calling', '1', 'who cooks for you?', 'heard in the distance', 13),
(1, '2021-09-30', '08:00', 'Bosque del Apache National Wildlife Refuge', 'wetlands', 'foggy', 'perched', '1', NULL, 'on a dead tree branch', 12),
(1, '2022-07-06', '17:30', 'Washington, D.C.', 'urban park', 'thunderstorms', 'in flight', '3', 'caw caw caw', 'flying towards the Capitol Building', 38),
(1, '2022-09-01', '16:15', 'Miami, Florida', 'beach', 'rainy', 'perched', '1', NULL, 'on a lifeguard stand', 33),
(1, '2023-05-01', '12:00', 'Chicago, Illinois', 'urban park', 'sunny', 'foraging', '2', 'chick-a-dee-dee-dee', NULL, 26),
(1, '2021-10-27', '10:45', 'Sedona, Arizona', 'red rocks', 'sunny', 'perched', '1', NULL, 'on a rock formation', 9),
(1, '2022-06-02', '16:30', 'Yellowstone National Park', 'forest', 'partly cloudy', 'foraging', '2', 'chip-chip-chip-chip', NULL, 2),
(1, '2022-07-17', '10:15', 'Cape May, New Jersey', 'coastal', 'sunny', 'flying', '1', NULL, 'Breeding plumage', 2),
(1, '2022-11-26', '07:55', 'Central Park, New York', 'urban park', 'cloudy', 'resting', '1', NULL, 'Leg band: blue on right leg', 2),
(1, '2022-05-13', '06:20', 'Adirondack Mountains, New York', 'forest', 'foggy', 'singing', '1', 'who-cooks-for-you', NULL, 3),
(1, '2021-05-15', '07:30', 'Yellowstone National Park', 'forest', 'partly cloudy', 'flying', '2', 'chirp chirp', 'Saw the bird in the morning', 3),
(1, '2022-03-22', '13:45', 'Brooklyn Botanic Garden', 'garden', 'sunny', 'resting', '1', NULL, 'On a tree branch', 2),
(1, '2022-06-01', '11:00', 'Golden Gate Park, San Francisco', 'park', 'sunny', 'feeding', '3', NULL, 'Found in the bushes', 10),
(1, '2021-08-19', NULL, 'Stanley Park, Vancouver, Canada', 'park', 'cloudy', 'flying', '2', NULL, 'A pair of birds', 19),
(1, '2022-07-05', '16:30', 'Seattle, Washington', 'urban', 'sunny', 'singing', '1', 'tweet tweet tweet', NULL, 23),
(1, '2021-09-11', '09:00', 'Central Park, New York', 'urban park', 'cloudy', 'flying', '1', NULL, 'Small bird', 29),
(1, '2023-04-23', '07:00', 'Niagara Falls, New York', 'waterfall', 'rainy', 'flying', '1', NULL, 'Near the falls', 31),
(1, '2021-09-13', '08:15', 'The Everglades, Florida', 'marshland', 'sunny', 'perching', '2', NULL, 'Seen near the water', 2),
(1, '2022-05-10', '14:30', 'Banff National Park, Alberta, Canada', 'mountains', 'partly cloudy', 'flying', '1', NULL, 'Saw while hiking', 4),
(1, '2022-06-01', NULL, 'Yellowstone National Park, Wyoming', 'woodland', 'overcast', 'foraging', '4', NULL, 'Pecking at the ground', 6),
(1, '2022-07-20', '11:00', 'The Grand Canyon, Arizona', 'desert', 'hot and dry', 'soaring', '1', NULL, 'Flying high above', 8),
(1, '2022-09-05', '09:15', 'Central Park, New York', 'urban park', 'sunny', 'perching', '1', NULL, 'Seen on a bench', 10),
(1, '2022-10-17', NULL, 'Yosemite National Park, California', 'forest', 'rainy', 'flying', '2', NULL, 'Flying through the trees', 12),
(1, '2023-02-14', '16:45', 'Acadia National Park, Maine', 'coastline', 'partly cloudy', 'resting', '1', NULL, 'Sitting on a rock', 16),
(1, '2023-04-02', '10:30', 'The Great Smoky Mountains, Tennessee', 'mountains', 'foggy', 'singing', '1', 'tweet tweet tweet', 'Heard from a distance', 18),
(1, '2023-05-01', '08:00', 'Central Park, New York', 'urban park', 'sunny', 'nesting', '2', NULL, 'Building a nest in a tree', 20),
(1, '2021-11-22', '15:00', 'The Grand Canyon, Arizona', 'desert', 'hot and dry', 'flying', '1', NULL, 'Soaring over the canyon', 8),
(1, '2021-12-05', '11:30', 'Central Park, New York', 'urban park', 'cloudy', 'foraging', '3', NULL, 'Pecking at the ground for food', 10),
(1, '2022-02-08', '13:00', 'Everglades National Park, Florida', 'marshland', 'sunny', 'perching', '1', NULL, 'Seen on a post', 2),
(1, '2022-03-10', NULL, 'Montréal, Canada', NULL, 'snowing', 'in flight', '10', NULL, 'Flying in formation with others', 1),
(1, '2022-04-15', '09:00', 'Yellowstone National Park, Wyoming', 'woodland', 'sunny', 'perching', '1', NULL, 'Seen on a branch', 6),
(1, '2022-06-03', 'afternoon', 'Banff National Park, Alberta, Canada', 'mountains', 'partly cloudy', 'foraging', '2', NULL, 'Eating berries', 41),
(1, '2023-05-02', '08:15', 'Yellowstone National Park', 'forested area near river', 'sunny', 'foraging', '1', NULL, 'Observed the bird using its beak to break open a nut', 2),
(1, '2022-09-07', '06:30', 'Everglades National Park', 'swamp', 'partly cloudy', 'singing', '2', 'tweet tweet coo', NULL, 3),
(1, '2023-01-15', '10:00', 'Red Rock Canyon State Park, California', 'desert', 'sunny', 'perching', '1', NULL, 'First sighting of this bird species in this area', 4),
(1, '2022-06-10', '14:30', 'Yosemite National Park', 'forest', 'sunny', 'flying', '3', NULL, 'A group of three birds observed chasing each other', 5),
(1, '2022-11-27', 'noon', 'Grand Canyon National Park', 'canyon', 'clear sky', 'foraging', '1', NULL, NULL, 6),
(1, '2023-02-18', '09:20', 'Acadia National Park, Maine', 'coastal forest', 'partly cloudy', 'perching', '1', NULL, 'Bird was observed near the entrance of the park', 7),
(1, '2022-08-01', '18:45', 'Great Smoky Mountains National Park', 'mountain', 'clear sky', 'singing', '1', 'twit twit twoo', NULL, 8),
(1, '2022-05-05', 'morning', 'El Yunque National Forest, Puerto Rico', 'tropical rainforest', 'sunny', 'foraging', '2', 'repeated trill', NULL, 2),
(1, '2022-03-15', 'afternoon', 'Everglades National Park, Florida', 'wetlands', 'partly cloudy', 'flying', '3', NULL, 'Seen near a pond', 3),
(1, '2021-11-28', NULL, 'Yellowstone National Park, Wyoming', 'woodland', NULL, 'perched on a tree', '1', 'repeated whistle', NULL, 5),
(1, '2021-07-14', 'evening', 'Cape May, New Jersey', 'coastal habitat', 'foggy', 'flying', '7', NULL, 'Flying over the beach', 6),
(1, '2023-05-01', 'afternoon', 'Central Park, New York', 'urban park', 'sunny', 'foraging', '6', 'chirp-chirp-chirp', 'feeding on seeds from a tree', 2),
(1, '2023-05-02', '08:00', 'Montréal, Canada', NULL, 'sunny', 'singing', '1', 'twee-twee-twee', 'heard singing in a tree', 3),
(1, '2023-05-03', 'morning', 'Grand Teton National Park', 'mountain lake', 'partly cloudy', 'swimming', '3', NULL, 'seen swimming in the lake', 5),
(1, '2023-05-04', '10:30', 'Jaques Cartier National Park, Quebec, Canada', 'forest', 'overcast', 'foraging', '2', 'pik-pik-pik', 'heard tapping on a tree', 6),
(1, '2023-05-05', '07:00', 'Central Park, New York', 'urban park', 'partly cloudy', 'flying', '1', NULL, 'seen flying over the lake', 7),
(1, '2023-05-06', '09:30', 'Montréal, Canada', 'riverside', 'sunny', 'foraging', '3', 'chik-chik-chik', 'seen searching for insects on the ground', 8),
(1, '2023-05-07', 'afternoon', 'Central Park, New York', 'urban park', 'sunny', 'singing', '1', 'tweet-tweet-tweet', 'heard singing in a tree', 9),
(1, '2023-05-08', 'morning', 'Grand Teton National Park', 'mountain forest', 'overcast', 'foraging', '2', 'peep-peep', 'seen hopping on the forest floor', 10),
(1, '2023-05-09', '08:30', 'Jaques Cartier National Park, Quebec, Canada', 'mountain trail', 'sunny', 'flying', '1', NULL, 'seen flying over the trail', 11),
(1, '2023-05-10', 'afternoon', 'Central Park, New York', 'urban park', 'sunny', 'singing', '1', 'chirp-chirp-chirp', 'heard singing in a tree', 12),
(1, '2023-05-11', '09:00', 'Montréal, Canada', 'park', 'partly cloudy', 'foraging', '5', 'chik-chik-chik', 'seen searching for insects on the ground', 13),
(1, '2023-05-12', 'mid day', 'Central Park, New York', 'urban park', 'sunny', 'flying', '1', NULL, 'seen flying over the lake', 15),
(1, '2023-05-13', '08:00', 'Grand Teton National Park', 'mountain meadow', 'sunny', 'foraging', '2', 'peep-peep', 'seen hopping on the meadow', 16),
(1, '2023-05-04', 'afternoon', 'Central Park, New York', 'urban park', 'sunny', 'resting', '2', NULL, NULL, 2),
(1, '2023-05-04', 'morning', 'Big Bend National Park, Texas', 'desert', 'sunny and hot', 'foraging', '1', NULL, 'First observation of the season', 3),
(1, '2023-05-04', NULL, 'Everglades National Park, Florida', 'swamp', 'humid and rainy', 'flying', '3', NULL, NULL, 5),
(1, '2023-05-04', 'dusk', 'Grand Canyon National Park, Arizona', 'canyon', 'clear', 'flying', '5', NULL, 'Beautiful sighting', 6),
(1, '2023-05-04', 'midnight', 'Yosemite National Park, California', 'forest', 'clear', 'perched', '1', NULL, NULL, 8),
(1, '2023-05-04', NULL, 'Yellowstone National Park, Wyoming', 'meadow', 'partly cloudy', 'singing', '2', 'Whistle-like notes', NULL, 9),
(1, '2023-05-04', '08:30', 'Glacier National Park, Montana', 'mountain', 'sunny', 'foraging', '1', NULL, 'Observed near a glacier', 10),
(1, '2023-05-04', '15:20', 'Cape May, New Jersey', 'coast', 'windy', 'flying', '10', NULL, NULL, 11),
(1, '2023-05-04', NULL, 'Aransas National Wildlife Refuge, Texas', 'wetland', 'sunny', 'swimming', '3', NULL, NULL, 12),
(1, '2023-05-04', 'morning', 'Baxter State Park, Maine', 'forest', 'misty', 'perched', '1', NULL, 'First observation ever', 13),
(1, '2023-05-04', '11:00', 'Jasper National Park, Alberta, Canada', 'mountain', 'sunny', 'foraging', '2', NULL, 'Observed near a lake', 15),
(1, '2023-05-04', 'afternoon', 'Prince Edward Island National Park, Canada', 'coast', 'cloudy', 'flying', '5', NULL, 'Beautiful colors', 16),
(1, '2023-05-04', NULL, 'Olympic National Park, Washington', 'forest', 'rainy', 'perched', '1', NULL, NULL, 17),
(1, '2023-05-04', 'mid day', 'Denali National Park and Preserve, Alaska', 'tundra', 'cloudy', 'foraging', '1', NULL, 'Observed near a river', 18),
(1, '2023-05-04', NULL, 'Crater Lake National Park, Oregon', 'mountain', 'clear', 'flying', '2', NULL, NULL, 19),
(1, '2023-05-04', 'dawn', 'Acadia National Park, Maine', 'coast', 'foggy', 'singing', '1', 'Beautiful melody', NULL, 20),
(1, '2023-05-04', 'morning', 'Central Park, New York', 'urban park', 'sunny', 'flying', '1', NULL, 'First sighting of the season', 2),
(1, '2023-05-04', 'afternoon', 'Central Park, New York', 'urban park', 'sunny', 'feeding', '3', 'Chirping', 'Seen around the pond', 7),
(1, '2023-05-04', 'evening', 'Central Park, New York', 'urban park', 'partly cloudy', 'roosting', '5', NULL, NULL, 12),
(1, '2023-05-04', 'dusk', 'Central Park, New York', 'urban park', 'partly cloudy', 'flying', '1', NULL, NULL, 17),
(1, '2023-05-04', 'afternoon', 'Central Park, New York', 'urban park', 'sunny', 'foraging', '2', 'Whistling', NULL, 20),
(1, '2023-05-04', 'morning', 'Central Park, New York', 'urban park', 'sunny', 'flying', '1', NULL, NULL, 22),
(1, '2023-05-04', 'noon', 'Central Park, New York', 'urban park', 'partly cloudy', 'feeding', '3', 'Chirping', NULL, 28),
(1, '2023-05-04', 'afternoon', 'Central Park, New York', 'urban park', 'sunny', 'resting', '1', NULL, 'Nesting near the pond', 32),
(1, '2023-05-04', 'morning', 'Central Park, New York', 'urban park', 'sunny', 'flying', '2', 'Squawking', NULL, 36),
(1, '2023-05-04', 'dawn', 'Central Park, New York', 'urban park', 'clear', 'singing', '1', 'Melodic song', 'First sighting of the season', 39),
(1, '2023-04-25', '7:00 AM', 'Central Park', 'Urban Park', 'Partly Cloudy', 'Flying', 'Several', 'Repeated Whistle', 'Observed in a group of sparrows', 27),
(1, '2023-04-25', '8:30 AM', 'Brooklyn Botanic Garden', 'Botanical Garden', 'Sunny', 'Perching', 'Approximately 10', 'Short Chirp', 'Male birds had bright red markings', 40),
(1, '2023-04-26', '6:45 AM', 'Jamaica Bay Wildlife Refuge', 'Coastal Wetland', 'Foggy', 'Foraging', 'A few', 'No Song', 'Birds seen near the water', 21),
(1, '2023-04-26', '12:00 PM', 'Central Park', 'Urban Park', 'Sunny', 'Perching', 'Several', 'Melodic Song', 'Observed near a water fountain', 37),
(1, '2023-04-27', '7:15 AM', 'Bronx Zoo', 'Zoo', 'Overcast', 'Perching', 'Approximately 5', 'Rapid Trill', 'Birds were in an enclosed exhibit', 24),
(1, '2023-04-27', '9:00 AM', 'The High Line', 'Urban Park', 'Partly Cloudy', 'Flying', 'Many', 'Descending Notes', 'Observed flying in a circular pattern', 30),
(1, '2023-04-28', '8:30 AM', 'Central Park', 'Urban Park', 'Sunny', 'Foraging', 'Several', 'Warbling', 'Birds seen near a dog park', 43),
(1, '2023-04-28', '11:00 AM', 'Prospect Park', 'Urban Park', 'Overcast', 'Foraging', 'Approximately 10', 'No Song', 'Birds were feeding on insects', 35);
