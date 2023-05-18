import itertools
import os
import time

import cv2
import ffmpeg
from numpy import log
from PIL import Image
from tqdm import tqdm


def process_frame(
    path_to_frame: str,
) -> tuple[str, float, float, float, float, float, float]:
    im = Image.open(path_to_frame)
    width, height = im.size
    pix = im.load()
    r = g = b = 0
    energy_avg = sigma = entropy = 0.0
    frame_area = width * height
    for w, h in itertools.product(range(width), range(height)):
        r += pix[w, h][0]
        g += pix[w, h][1]
        b += pix[w, h][2]
    r_avg = r / frame_area
    g_avg = g / frame_area
    b_avg = b / frame_area
    energy_avg = (r_avg + g_avg + b_avg) / 3

    histogram = [0 for _ in range(256)]
    for w, h, ch in itertools.product(range(width), range(height), range(3)):
        sigma += (pix[w, h][ch] - energy_avg) ** 2
        histogram[pix[w, h][ch]] += 1
    sigma = (sigma / frame_area) ** 0.5

    for i in range(256):
        prob = histogram[i] / (3 * frame_area)
        if prob > 0:
            entropy += -prob * log(prob)

    im.close()
    image_name = path_to_frame.split("/")[-1]
    return (image_name, energy_avg, r_avg, g_avg, b_avg, sigma, entropy)


class LoadMovie:
    def __init__(
        self,
        video_path: str,
        CLEAR_MEMORY=True,
    ) -> None:
        self.video_path = video_path
        self.CLEAR_MEMORY = CLEAR_MEMORY

        probe = ffmpeg.probe(video_path)
        video_info = next(s for s in probe["streams"] if s["codec_type"] == "video")
        self.frame_width = int(video_info["width"])
        self.frame_height = int(video_info["height"])
        self.total_frames = int(video_info["nb_frames"])
        self.fps = int(video_info["r_frame_rate"].split("/")[0]) / 1000
        self.frames_output, video_format = os.path.splitext(self.video_path)

    def export_all_frames(self):
        """Exports all frames from video to a folder with its name"""
        # Create folder for frames
        if not os.path.isdir(self.frames_output):
            os.mkdir(self.frames_output)

        # Calling FFMPEG to export all frames
        ffmpeg.input(self.video_path).output(
            f"{self.frames_output}/%06d.bmp", start_number=1
        ).run(quiet=True)
        # .overwrite_output().run(quiet=True)

    def process_all_frames(self, clear_memory=False):
        if not hasattr(self, "frames_output"):
            print("BAD, run export_all_frames first or chose one_by_one")
            # Exception, error handling!!
            return False
        output_dat = f"{self.frames_output}.dat"
        if os.path.exists(output_dat):
            raise ValueError(
                "Ya se ha procesado este video, no se procesará dos veces."
            )

        images_to_process = sorted(os.listdir(self.frames_output))
        for image_name in tqdm(images_to_process):
            frame_path = f"{self.frames_output}/{image_name}"
            append_write = "a" if os.path.exists(output_dat) else "w"
            with open(output_dat, append_write) as f:
                f.write(";".join(str(x) for x in process_frame(frame_path)) + "\n")

            if clear_memory:  # Implementar esta opción
                os.remove(f"{self.frames_output}/{image_name}")

    def one_by_one(self):
        video = cv2.VideoCapture(self.video_path)
        try:
            if not os.path.exists(self.frames_output):
                os.mkdir(self.frames_output)
        except OSError:
            print("Error: Creating directory for frames.")  # Mejora esto.

        output_dat = f"{self.frames_output}.dat2"

        currentframe = 0
        while True:
            # reading set frame, initially 0
            status, frame = video.read()
            if status:
                # if video is still left continue creating images
                # save frame
                frame_path = f"{self.frames_output}/{currentframe + 1:06d}.bmp"

                # writing the extracted images
                cv2.imwrite(frame_path, frame)

                # HACER UN PROCESS_FRAME QUE TRABAJE SIN FICHERO, SOBRE IMAGEN EN MEMORIA
                append_write = "a" if os.path.exists(output_dat) else "w"
                with open(output_dat, append_write) as f:
                    f.write(";".join(str(x) for x in process_frame(frame_path)) + "\n")

                os.remove(frame_path)
                # increasing counter so that it will
                # show how many frames are created
                currentframe += 1  # i.e. at 30 fps, this advances one second
                video.set(1, currentframe)
            else:
                break

        # Release all space and windows once done
        video.release()
        cv2.destroyAllWindows()

        # for frame_nb in tqdm(range(1, self.total_frames + 1)):
        #     output_frame = f"{self.frames_output}/{frame_nb:06d}.bmp"
        #     in_file = ffmpeg.input(self.video_path, ss=frame_nb / self.fps)
        #     in_file.output(output_frame, vframes=1).run(quiet=True)


if __name__ == "__main__":
    test = LoadMovie("example_raw/color_test.3gp")

    # start = time.time()
    # test.export_all_frames()
    # print("All exported, now processing:")
    # test.process_all_frames(clear_memory=True)
    # print("All processed.")
    # end = time.time()
    # print("En bloque ha tardado:", end - start)

    start = time.time()
    test.one_by_one()
    end = time.time()
    print("Uno a uno ha tardado:", end - start)
