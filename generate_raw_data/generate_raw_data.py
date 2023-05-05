# Clase y métodos para a partir de un archivo de vídeo generar el .dat
# y el json con los metadatos
import os
import ffmpeg
import numpy as np
from PIL import Image

# from PIL import Image

# Implementar esta opción para borrar las imagenes
CLEAR_MEMORY = True


# OJO CON EL MANEJO DE RUTAS!! Va a fallar
video_path = "example_raw/color_test.3gp"
frames_output, video_format = os.path.splitext(video_path)
if not os.path.isdir(frames_output):
    os.mkdir(frames_output)


# Improve and check this is the correct method of detting metadata
probe = ffmpeg.probe(video_path)
video_info = next(s for s in probe["streams"] if s["codec_type"] == "video")
frame_width = int(video_info["width"])
frame_height = int(video_info["height"])
total_frames = int(video_info["nb_frames"])
fps = int(video_info["r_frame_rate"].split("/")[0]) / 1000


# in_file.output(f"{frames_output}/%06d.bmp", start_number=1).overwrite_output().run()
for frame in range(1, total_frames + 1):
    # if frame < 10:
    in_file = ffmpeg.input(video_path, ss=frame / fps)
    in_file.output(f"{frames_output}/{frame:06d}.bmp", vframes=1).run()

images_to_process = sorted(os.listdir(frames_output))
for image_name in images_to_process:
    im = Image.open(f"{frames_output}/{image_name}")
    pix = im.load()
    r = g = b = 0
    energia_media = sigma = suma_entropia = 0.0
    for w in range(frame_width):
        for h in range(frame_height):
            r += pix[w, h][0]
            g += pix[w, h][1]
            b += pix[w, h][2]
    suma_r = r / (frame_width * frame_height)
    suma_g = g / (frame_width * frame_height)
    suma_b = b / (frame_width * frame_height)
    energia_media = (suma_r + suma_g + suma_b) / 3

    histogram = [0 for _ in range(256)]
    for w in range(frame_width):
        for h in range(frame_height):
            for ch in range(3):
                sigma += (pix[w, h][ch] - energia_media) ** 2
                histogram[pix[w, h][ch]] += 1
    sigma = (sigma / (frame_width * frame_height)) ** 0.5

    for i in range(256):
        prob = histogram[i] / (3 * frame_width * frame_height)
        if prob > 0:
            suma_entropia += -prob * np.log(prob)

    im.close()
    if CLEAR_MEMORY:  # Implementar esta opción
        os.remove(f"{frames_output}/{image_name}")

    output_dat = f"{frames_output}/test_name"
    append_write = "a" if os.path.exists(output_dat) else "w"
    with open(output_dat, append_write) as f:
        f.write(
            f"{image_name};{energia_media};{suma_r};{suma_g};{suma_b};{sigma};{suma_entropia}\n"
        )


class LoadMovie:
    def __init__(self, video_path) -> None:
        self.video_path = video_path
