--[[
    Copyright (C) 2024 nick-s-b

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]--

local options = require 'mp.options'
local utils = require 'mp.utils'

-- Default options; Modify them in ~/.config/mpv/script-opts/transcript.conf file, not here.
local opt = {
    transcript_folder = os.getenv("HOME").."/transcripts",
    subtitle_lang = "en"
}

-- Read options from ~/.config/mpv/script-opts/transcript.conf
options.read_options(opt, "transcript")

-- ... make sure it exists
os.execute("mkdir -p " .. opt.transcript_folder)

-- Clean up the transcript file: remove timestamps, subtitle numbers, HTML tags, etc
local function clean_transcript_file(input_file, output_file)
    local infile = io.open(input_file, "r")
    local outfile = io.open(output_file, "w")

    if not infile then
        print("Error: Could not open input file " .. input_file)
        return
    end
    if not outfile then
        print("Error: Could not open output file " .. output_file)
        return
    end

    for line in infile:lines() do
        -- Remove ttml timestamps (e.g., 00:01:23,456 --> 00:01:25,678 or 00:01:23.456 --> 00:01:25.678)
        if not line:match("^%d%d:%d%d:%d%d[,%.]%d%d%d%s+-->%s+%d%d:%d%d:%d%d[,%.]%d%d%d$") then
            -- Remove subtitle numbers (1, 2, 3, etc.)
            if not line:match("^%d+$") then
                -- Remove HTML tags (e.g., <i>, <b>, etc.)
                line = line:gsub("<[^>]+>", "")
                -- Write the cleaned line if it's not empty or just whitespace...
                if line:match("%S") then
                    outfile:write(line .. "\n")
                end
            end
        end
    end

    infile:close()
    outfile:close()
end

-- mpv event listener
mp.register_event("file-loaded", function()
    local file_path = mp.get_property("path")
    
    -- Check if it's a YouTube video
    if file_path:match("^https://www%.youtube%.com/watch%?v=") or file_path:match("^https://youtu%.be/") then
        -- Get the media title from mpv
        local media_title = mp.get_property("media-title")
        
        -- Sanitize the media title to be safe for file names
        local sanitized_title = media_title:gsub("[/:?\"<>|%*]", "_")

        -- Extract the video ID
        local video_id = file_path:match("v=([%w_-]+)") or file_path:match("youtu%.be/([%w_-]+)")

        -- Set the output path for the transcript
        local output_transcript = opt.transcript_folder.."/"..sanitized_title.."_"..video_id..".transcript.txt"
        
        -- Download the transcript using yt-dlp
        local transcript_command = string.format('yt-dlp --skip-download --write-subs --write-auto-subs --sub-lang %s --sub-format ttml -o "%s" "%s"',
                                                 opt.subtitle_lang, opt.transcript_folder.."/%(id)s.%(ext)s", file_path)
        os.execute(transcript_command)

        -- Default file will be a .ttml
        local downloaded_transcript_file = opt.transcript_folder.."/"..video_id.."."..opt.subtitle_lang..".ttml"

        -- Clean up the transcript file and save it with the video's title
        clean_transcript_file(downloaded_transcript_file, output_transcript)

        -- Delete the original .ttml file
        os.remove(downloaded_transcript_file)

        mp.osd_message("Downloaded and cleaned transcript for: " .. sanitized_title .. "_" .. video_id)
    else
        mp.osd_message("Debug: Not a YouTube video, skipping transcript download.")
    end
end)