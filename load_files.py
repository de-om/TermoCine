import json
import pathlib

movie_list_path = "data/movies.json"


class Movie:
    def __init__(self, film_number: int):
        self.film_number = film_number
        self.selected_film = f"film{film_number}"

        self.title = self.metadata["title"]
        self.path = self.metadata["path"]
        self.frame_height = self.metadata["frame_height"]
        self.frame_width = self.metadata["frame_width"]
        self.fps = self.metadata["fps"]
        self.initial_frame = self.metadata["initial_frame"]
        self.final_frame = self.metadata["final_frame"]
        self.reference_n_shots = self.metadata["reference_n_shots"]

    @property
    def metadata(self):
        movie_list = json.loads(pathlib.Path(movie_list_path).read_text())
        return movie_list[self.selected_film]

    @property
    def is_experimental(self):
        return not 1 <= self.film_number <= 7

    # Implement methods to print(Movie) and so on


class MovieVariables(Movie):
    def __init__(self, film_number: int):
        super().__init__(film_number)

        self.frame_names = []
        self.energy = []
        self.sigma = []
        self.r_energy = []
        self.g_energy = []
        self.b_energy = []
        self.entropy = []
        with open(self.path) as f:
            for line in f:
                frame_variables = [x.strip() for x in line.split(";")]
                self.frame_names.append(frame_variables[0])
                self.energy.append(float(frame_variables[1]))
                self.sigma.append(float(frame_variables[2]))
                self.r_energy.append(float(frame_variables[3]))
                self.g_energy.append(float(frame_variables[4]))
                self.b_energy.append(float(frame_variables[5]))
                self.entropy.append(float(frame_variables[6]))

    # Implement methods to print(Movie) and so on


class MovieDeltas(MovieVariables):
    def __init__(self, film_number: int):
        super().__init__(film_number)

        self.delta_energy = []
        self.abs_delta_energy = []
        for energy1, energy2 in zip(self.energy, self.energy[1:]):
            delta_e = energy2 - energy1
            self.delta_energy.append(delta_e)
            self.abs_delta_energy.append(abs(delta_e))
        self.delta_entropy = []
        self.abs_delta_entropy = []
        for entropy1, entropy2 in zip(self.entropy, self.entropy[1:]):
            delta_e = entropy2 - entropy1
            self.delta_entropy.append(delta_e)
            self.abs_delta_entropy.append(abs(delta_e))
