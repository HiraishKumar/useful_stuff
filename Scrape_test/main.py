from yt_dlp import YoutubeDL

URL = "https://www.youtube.com/@GlueFactoryPodcast/videos"

ydl_opts = {
    'extract_flat': True,  # Only list video data, no download
    'quiet': True           # Suppress console output
}

with YoutubeDL(ydl_opts) as ydl:
    info = ydl.extract_info(URL, download=False)
    video_titles = [[entry['title'],entry['view_count']] for entry in info['entries'] ]
    print(info.keys())
    

# for item in video_titles:
#     print(item)