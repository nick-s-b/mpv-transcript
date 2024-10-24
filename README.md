# 📜 YouTube Transcript Downloader for mpv

This [mpv](https://github.com/mpv-player/mpv) Lua script automatically downloads and cleans up YouTube video transcripts and saves them as plain text (`.txt`) files. It uses [yt-dlp](https://github.com/yt-dlp/yt-dlp) to download the transcripts, removes unnecessary formatting, and saves a clean version for easier reading or recall.

## Introduction

Have you ever watched a YouTube video and, weeks or months later, wanted to refer to it but couldn't remember the title or find it again? Well, this script can help! 

It simplifies the process of extracting and saving YouTube transcripts as text files. Once saved, you can use `grep` or your file manager's text search function to easily find words or phrases from videos you've watched.


## Installation

To install and set up the script:

1. **Dependencies**:
   - [mpv](https://mpv.io/)
   - [yt-dlp](https://github.com/yt-dlp/yt-dlp)

2. **Download the script**:
   - Clone or download this repository and copy the Lua script to your `~/.config/mpv/scripts/` directory. For example, you can clone the repository and create a symbolic link to the script with the following commands:

     ```bash
     mkdir -p ~/sources/
     cd ~/sources/
     git clone https://github.com/nick-s-b/mpv-transcript.git
     mkdir -p ~/.config/mpv/scripts/
     ln -sr mpv-transcript/scripts/transcript.lua ~/.config/mpv/scripts/transcript.lua
     ```


## Configuration

You can configure the script by copying the default configuration file:
   ```bash
   cp script-opts/transcript.conf ~/.config/mpv/script-opts/
   ```

and by editing the file:

   ```bash
   nano ~/.config/mpv/script-opts/transcript.conf
   ```


### `transcript.conf` options:

- **`transcript_folder`**: Defines the folder where the cleaned transcripts will be saved. By default, it saves the transcripts in `~/transcripts/`. You can change this path as needed.
  
- **`subtitle_lang`**: Specifies the language for YouTube subtitles. The default value is `"en"` (English), but you can set it to any supported YouTube subtitle language code.

## Limitations:

`mpv-transcript` does not perform speech recognition or translation on its own; it relies on YouTube to provide these services. Some new videos may not have transcripts available immediately, and the language specified in your configuration might not be available. In such cases, `mpv-transcript` will fail to download the transcript.

The solution is to try again later. In some instances, simply requesting a transcript or translation that isn't ready yet can prompt YouTube to generate it.

## Usage

Once everything is set up, simply play a YouTube video with `mpv`, and the script will automatically save the transcript.

### Contributing

If you have a suggestion, leave an issue or just create a pull request.

## License

This project is licensed under the GPLv3. See the [LICENSE](LICENSE) file for more details.
