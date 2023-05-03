from load_files import Movie

default_movies = Movie.load_default_movies("data/")

for movie in default_movies:
    movie.load_data()
    movie.process_data_to_deltas()

for film in default_movies:
    print(film)
