# neofetch(1)
set -l has __fish_contains_opt
set -l bool on off

complete -c neofetch -f

# INFO
complete -c neofetch -x -l disable -d 'Disable an info line'
complete -c neofetch -x -l package_managers -d 'Show Package Manager names' -a "$bool tiny"
complete -c neofetch -x -l os_arch -d 'Show OS architecture' -a "$bool"
complete -c neofetch -x -l speed_type -d 'Type of CPU speed to show' -a "current min max bios scaling_current scaling_min scaling_max"
complete -c neofetch -x -l speed_shorthand -d 'Show decimals in CPU speed' -a "$bool"
complete -c neofetch -x -l cpu_brand -d 'Show CPU brand' -a "$bool"
complete -c neofetch -x -l cpu_cores -d 'Show number of CPU cores' -a "logical physical off"
complete -c neofetch -x -l cpu_speed -d 'Show CPU speed' -a "$bool"
complete -c neofetch -x -l cpu_temp -d 'Show CPU temperature' -a "C\tCelcius F\tFahrenheit off\t'Disable temperature'"
complete -c neofetch -x -l distro_shorthand -d 'Shorten distro' -a "$bool tiny"
complete -c neofetch -x -l kernel_shorthand -d 'Shorten kernel' -a "$bool"
complete -c neofetch -x -l uptime_shorthand -d 'Shorten uptime' -a "$bool tiny"
complete -c neofetch -x -l refresh_rate -d 'Show refresh rate of monitors' -a "$bool"
complete -c neofetch -x -l gpu_brand -d 'Show GPU brand' -a "$bool"
complete -c neofetch -x -l gpu_type -d 'Which GPU to show' -a "all dedicated integrated"
complete -c neofetch -x -l de_version -d 'Show Desktop Environment version' -a "$bool"
complete -c neofetch -x -l gtk_shorthand -d 'Shorten GTK theme/icons' -a "$bool"
complete -c neofetch -x -l gtk2 -d 'Show GTK2 theme/font/icons' -a "$bool"
complete -c neofetch -x -l gtk3 -d 'Show GTK3 theme/font/icons' -a "$bool"
complete -c neofetch -x -l shell_path -d 'Show $SHELL path' -a "$bool"
complete -c neofetch -x -l shell_version -d 'Show $SHELL version' -a "$bool"
complete -c neofetch -x -l disk_show -d 'Which disks to display' # TODO add args
complete -c neofetch -x -l disk_subtitle -d 'What info to add to the Disk subtitle' -a "name mount dir none"
complete -c neofetch -x -l disk_percent -d 'Show disk percent' -a "$bool"
complete -c neofetch -x -l ip_host -d 'URL to query for public IP' # TODO add URL arg
complete -c neofetch -x -l ip_timeout -d 'Public IP timeout (in seconds)'
complete -c neofetch -x -l song_format -d 'Format for song info'
complete -c neofetch -x -l song_shorthand -d 'Print Artist/Album/Title on separate lines' -a "$bool"
complete -c neofetch -x -l memory_percent -d 'Print memory percentage' -a "$bool"
complete -c neofetch -x -l music_player -d 'Music player to use' # TODO add args

# TEXT FORMATTING
complete -c neofetch -x -l colors -d 'Change text colors' -n "! $has stdout"
complete -c neofetch -x -l underline -d 'Enable underline' -a "$bool"
complete -c neofetch -x -l underline_char -d 'Character to underline title with' -n "contains_seq --underline on -- (commandline -poc)"
complete -c neofetch -x -l bold -d 'Enable bold text' -a "$bool"
complete -c neofetch -x -l separator -d 'Change the separator'

# COLOR BLOCKS
set -l has_color_blocks "contains_seq --color_blocks on -- (commandline -poc)"

complete -c neofetch -x -l color_blocks -d 'Enable color blocks' -a "$bool" -n "! $has stdout"
complete -c neofetch -x -l col_offset -d 'Left-padding of color blocks' -n "$has_color_blocks"
complete -c neofetch -x -l block_width -d 'Width of color blocks' -n "$has_color_blocks"
complete -c neofetch -x -l block_height -d 'Height of color blocks' -n "$has_color_blocks"
complete -c neofetch -x -l block_range -d 'Range of colors to print as blocks' -n "$has_color_blocks"

# BARS
set -l bar_types bar infobar barinfo off

complete -c neofetch -x -l bar_char -d 'Characters to draw bars with'
complete -c neofetch -x -l bar_border -d "Surround bars with '[]'" -a "$bool"
complete -c neofetch -x -l bar_length -d 'Length to make bars'
complete -c neofetch -x -l bar_colors -d 'Colors to make bars' -n "! $has stdout"
complete -c neofetch -x -l cpu_display -d 'Bar mode' -a "$bar_types"
complete -c neofetch -x -l memory_display -d 'Bar mode' -a "$bar_types"
complete -c neofetch -x -l battery_display -d 'Bar mode' -a "$bar_types"
complete -c neofetch -x -l disk_display -d 'Bar mode' -a "$bar_types"

# IMAGE BACKEND
set -l img_backend ascii caca chafa iterm2 jp2a kitty pixterm sixel termpix tycat w3m off

complete -xc neofetch -l backend -d 'Image backend to use' -a "ascii caca chafa jp2a iterm2 off sixel tycat w3m kitty" -n "! $has $img_backend stdout"
complete -rc neofetch -l source -d 'Image source' -a "auto ascii wallpaper" -n "! $has stdout"
complete -c neofetch -l ascii -d "Use 'ascii' backend" -n "! $has backend $img_backend stdout"
complete -c neofetch -l caca -d "Use 'caca' backend" -n "! $has backend $img_backend stdout"
complete -c neofetch -l chafa -d "Use 'chafa' backend" -n "! $has backend $img_backend stdout"
complete -c neofetch -l iterm2 -d "Use 'iterm2' backend" -n "! $has backend $img_backend stdout"
complete -c neofetch -l jp2a -d "Use 'jp2a' backend" -n "! $has backend $img_backend stdout"
complete -c neofetch -l kitty -d "Use 'kitty' backend" -n "! $has backend $img_backend stdout"
complete -c neofetch -l pixterm -d "Use 'pixterm' backend" -n "! $has backend $img_backend stdout"
complete -c neofetch -l sixel -d "Use 'sixel' backend" -n "! $has backend $img_backend stdout"
complete -c neofetch -l termpix -d "Use 'termpix' backend" -n "! $has backend $img_backend stdout"
complete -c neofetch -l tycat -d "Use 'tycat' backend" -n "! $has backend $img_backend stdout"
complete -c neofetch -l w3m -d "Use 'w3m' backend" -n "! $has backend $img_backend stdout"
complete -c neofetch -l off -d 'Disable ascii art' -n "! $has backend $img_backend stdout"

# ASCII
set -l backend_is_ascii "$has ascii || contains_seq --backend ascii -- (commandline -poc)"

complete -c neofetch -x -l ascii_colors -d 'Colors to print the ascii art' -n "$backend_is_ascii && ! $has stdout"
complete -c neofetch -x -l ascii_distro -d "Which Distro's ascii art to print" -n "$backend_is_ascii && ! $has stdout"
complete -c neofetch -x -l ascii_bold -d 'Bold the ascii logo' -n "$backend_is_ascii && ! $has stdout" -a "$bool"
complete -c neofetch -sL -l logo -d 'Only show the ascii logo' -n "$backend_is_ascii && ! $has stdout"

# IMAGE
set -l backend_is_w3m "$has w3m || contains_seq --backend w3m -- (commandline -poc)"
set -l msg_how_close "How close the image will be to the"

complete -c neofetch -l loop -d 'Redraw image constantly' -n "! $has stdout"
complete -xc neofetch -l size -d 'How to size the image' -n "! $has stdout"
complete -xc neofetch -l crop_mode -d 'Crop mode to use' -a "normal fit fill" -n "! $has stdout"
complete -xc neofetch -l crop_offset -d 'Crop offset' -a "northwest north northeast west center east southwest south southeast" -n "contains_seq --crop_mode normal -- (commandline -poc)"
complete -xc neofetch -l xoffset -d "$msg_how_close left edge of the window" -n "$backend_is_w3m && ! $has stdout"
complete -xc neofetch -l yoffset -d "$msg_how_close top edge of the window" -n "$backend_is_w3m && ! $has stdout"
complete -xc neofetch -l bg_color -d 'Background color for transparent image' -n "$backend_is_w3m && ! $has stdout"
complete -xc neofetch -l gap -d 'Gap between image & text' -n "! $has stdout"
complete -c neofetch -l clean -d 'Delete cached files & thumbnails' -n "! $has stdout"

# OTHER
complete -rc neofetch -l config -d 'Config file' -a "none\t'Don\'t use a config file'" -n "! $has no_config"
complete -c neofetch -l no_config -d "Don't create the user config file" -n "! $has config no_config"
complete -c neofetch -l print_config -d 'Print default config file'
complete -c neofetch -l stdout -d 'Turn off all colors & disable images'
complete -c neofetch -l help -d 'Print help & exit'
complete -c neofetch -l version -d 'Show neofetch version'
complete -c neofetch -s v -d 'Show error messages.'
complete -c neofetch -o vv -d 'Show a verbose log for error reporting'

# DEVELOPER
complete -c neofetch -l gen-man -d 'Generate a manpage for Neofetch' -n "command -qs help2man"
