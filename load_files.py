import json
import os
import pathlib

import numpy as np


class Movie:
    count = 0

    def __init__(
        self,
        identificator: str,
        title: str,
        data_path: str,
        frame_width: int,
        frame_height: int,
        fps: float,
        initial_frame: int,
        final_frame: int,
        reference_n_shots: int,
    ):
        self.identificator = identificator
        self.title = title
        self.data_path = data_path
        self.frame_width = frame_width
        self.frame_height = frame_height
        self.fps = fps
        self.initial_frame = initial_frame
        self.final_frame = final_frame
        self.reference_n_shots = reference_n_shots

        Movie.count += 1

    # @property  # make values immutable (?)
    # def metadata(self):
    #     movie_list = json.loads(pathlib.Path(movie_list_path).read_text())
    #     return movie_list[self.selected_film]

    # @property
    # def is_experimental(self):
    #     return not 1 <= self.film_number <= 7

    def load_data(self) -> bool:  # Error management
        self.frame_names = []
        self.energy = []
        self.sigma = []
        self.r_energy = []
        self.g_energy = []
        self.b_energy = []
        self.entropy = []
        with open(self.data_path) as f:
            for line in f:
                frame_variables = [x.strip() for x in line.split(";")]
                self.frame_names.append(frame_variables[0])
                self.energy.append(float(frame_variables[1]))
                self.sigma.append(float(frame_variables[2]))
                self.r_energy.append(float(frame_variables[3]))
                self.g_energy.append(float(frame_variables[4]))
                self.b_energy.append(float(frame_variables[5]))
                self.entropy.append(float(frame_variables[6]))
        return True

    def process_data_to_deltas(self) -> bool:  # Error management
        energy = np.array(self.energy)
        self.delta_energy = list(energy[1:] - energy[:-1])
        self.abs_delta_energy = list(np.absolute(self.delta_energy))
        entropy = np.array(self.entropy)
        self.delta_entropy = list(entropy[1:] - entropy[:-1])
        self.abs_delta_entropy = list(np.absolute(self.delta_entropy))
        return True

    @staticmethod
    def load_default_movies(path: str) -> list["Movie"]:
        data_files = os.listdir(path)
        for file in data_files:
            if os.path.splitext(file)[1] == ".json":
                movie_list = json.loads(pathlib.Path(path + file).read_text())
        return [
            Movie(
                identificator,
                movie["title"],
                movie["path"],
                movie["frame_width"],
                movie["frame_height"],
                movie["fps"],
                movie["initial_frame"],
                movie["final_frame"],
                movie["reference_n_shots"],
            )
            for identificator, movie in movie_list.items()
        ]

    @classmethod
    def total_movies(cls) -> None:
        print(f"Total of {cls.count} movies loaded")
        return cls.count

    # Implement methods to print(Movie) and so on
    def __str__(self) -> str:
        n_frames = len(self.energy)
        return f"{self.title} tiene {n_frames} fotogramas a {self.fps} con una duración de {int(n_frames / self.fps)} segundos."
