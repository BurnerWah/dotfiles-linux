function to_mp4 --argument input output
    ffmpeg -vaapi_device /dev/dri/renderD128 -i $input -vf 'format=nv12,hwupload' -c:v hevc_vaapi -f mp4 -rc_mode 1 -qp 25 $output
end
