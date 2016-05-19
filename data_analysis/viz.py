import numpy as np
from PIL import Image
from os import path
import matplotlib.pyplot as plt
import random

from wordcloud import WordCloud, STOPWORDS

def grey_color_func(word, font_size, position, orientation, random_state=None, **kwargs):
    return "hsl(0, 0%%, %d%%)" % random.randint(60, 100)

d = path.dirname(__file__)

# read the mask image
# http://stencilgram.com/
mask = np.array(Image.open(path.join(d, "ukkstencil2.png")))

# text to process
text = open("output.txt").read()

# preprocessing the text a little bit
text = text.replace("Helsing", "Helsinki")

# adding own stopwords
stopwords = STOPWORDS.copy()

sw = open("finstop.txt").read()
swlist = sw.split('\n')
for word in swlist:
	stopwords.add(word)

wc = WordCloud(max_words=1000, mask=mask, stopwords=stopwords, margin=10,
               random_state=1).generate(text)
# store default colored image
default_colors = wc.to_array()
plt.title("Custom colors")
plt.imshow(wc.recolor(color_func=grey_color_func, random_state=3))
wc.to_file("kekkonen.png")
plt.axis("off")
plt.figure()
plt.title("Default colors")
plt.imshow(default_colors)
plt.axis("off")
plt.show()
