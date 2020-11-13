#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

# If the option `use_preview_script` is set to `true`,
# then this script will be called and its output will be displayed in ranger.
# ANSI color codes are supported.
# STDIN is disabled, so interactive scripts won't work properly

# This script is considered a configuration file and must be updated manually.
# It will be left untouched if you upgrade ranger.

# Because of some automated testing we do on the script #'s for comments need
# to be doubled up. Code that is commented out, because it's an alternative for
# example, gets only one #.

# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | Display stdout as preview
# 1    | no preview | Display no preview at all
# 2    | plain text | Display the plain content of the file
# 3    | fix width  | Don't reload when width changes
# 4    | fix height | Don't reload when height changes
# 5    | fix both   | Don't ever reload
# 6    | image      | Display the image `$IMAGE_CACHE_PATH` points to as an image preview
# 7    | image      | Display the file directly as an image

# Script arguments
FILE_PATH="${1}" # Full path of the highlighted file
PV_WIDTH="${2}"  # Width of the preview pane (number of fitting characters)
# shellcheck disable=SC2034 # PV_HEIGHT is provided for convenience and unused
PV_HEIGHT="${3}"        # Height of the preview pane (number of fitting characters)
IMAGE_CACHE_PATH="${4}" # Full path that should be used to cache image preview
PV_IMAGE_ENABLED="${5}" # 'True' if image previews are enabled, 'False' otherwise.

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

# Settings
HIGHLIGHT_SIZE_MAX=262143 # 256KiB
HIGHLIGHT_TABWIDTH=${HIGHLIGHT_TABWIDTH:-8}
HIGHLIGHT_STYLE="${HIGHLIGHT_STYLE:-molokai}"
export HIGHLIGHT_OPTIONS="--replace-tabs=${HIGHLIGHT_TABWIDTH} --style=${HIGHLIGHT_STYLE} ${HIGHLIGHT_OPTIONS:-}"
PYGMENTIZE_STYLE=${PYGMENTIZE_STYLE:-monokai}
OPENSCAD_IMGSIZE=${RNGR_OPENSCAD_IMGSIZE:-1000,1000}
OPENSCAD_COLORSCHEME=${RNGR_OPENSCAD_COLORSCHEME:-Tomorrow Night}

# handle_extension() {{{1
handle_extension() {
  case "${FILE_EXTENSION_LOWER}" in
    # Archive
    rz | t7z)
      atool --list -- "${FILE_PATH}" && exit 5
      bsdtar --list --file "${FILE_PATH}" && exit 5
      tar --list --file "${FILE_PATH}" && exit 5
      # exit 1
      ;;

    # OpenDocument
    sxw)
      ## Preview as text conversion
      odt2txt "${FILE_PATH}" && exit 5
      ## Preview as markdown conversion
      pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Direct Stream Digital/Transfer (DSDIFF) and wavpack aren't detected
    # by file(1).
    dff | dsf)
      mediainfo "${FILE_PATH}" && exit 5
      exiftool "${FILE_PATH}" && exit 5
      ;; # Continue with next handler on failure
  esac
}

# handle_image() {{{1
handle_image() {
  # Size of the preview if there are multiple options or it has to be
  # rendered from vector graphics. If the conversion program allows
  # specifying only one dimension while keeping the aspect ratio, the width
  # will be used.
  local DEFAULT_SIZE="1920x1080"

  openscad_image() {
    TMPPNG="$(mktemp -t XXXXXX.png)"
    openscad --colorscheme="${OPENSCAD_COLORSCHEME}" \
      --imgsize="${OPENSCAD_IMGSIZE/x/,}" \
      -o "${TMPPNG}" "${1}"
    mv "${TMPPNG}" "${IMAGE_CACHE_PATH}"
  }

  case "${FILE_EXTENSION_LOWER}" in
    # 3D models
    # OpenSCAD only supports png image output, and ${IMAGE_CACHE_PATH}
    # is hardcoded as jpeg. So we make a tempfile.png and just
    # move/rename it to jpg. This works because image libraries are
    # smart enough to handle it.
    csg | scad)
      openscad_image "${FILE_PATH}" && exit 6
      ;;
    3mf | amf | off | stl)
      openscad_image <(echo "import(\"${FILE_PATH}\");") && exit 6
      ;;
  esac
}

# handle_mime() {{{1
handle_mime() {
  local DEFAULT_SIZE="1920x1080"

  if [[ "$(tput colors)" -ge 256 ]]; then
    local pygmentize_format='terminal256'
    local highlight_format='xterm256'
  else
    local pygmentize_format='terminal'
    local highlight_format='ansi'
  fi

  local mimetype="${1}"
  case "${mimetype}" in

    # Text {{{2
    # JSON document {{{3
    application/json)
      # Fast parsed output
      jq --color-output . "${FILE_PATH}" && exit 5
      # Slightly slower parsed output
      python -m json.tool -- "${FILE_PATH}" && exit 5
      # Syntax highlighting
      highlight \
        --out-format="${highlight_format}" \
        --syntax=json \
        -- "${FILE_PATH}" && exit 5

      env COLORTERM=8bit bat \
        --color always \
        --style plain \
        --language json \
        -- "${FILE_PATH}" && exit 5

      pygmentize \
        -f "${pygmentize_format}" \
        -O "style=${PYGMENTIZE_STYLE}" \
        -l json \
        -- "${FILE_PATH}" && exit 5
      exit 2
      ;;

    # Markdown document {{{3
    text/markdown)
      if [[ "$(stat --printf='%s' -- "${FILE_PATH}")" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
        exit 2
      fi
      # Fully parsed preview
      mdv "${FILE_PATH}" && exit 5
      # Syntax highlighting
      env COLORTERM=8bit bat \
        --color always \
        --style plain \
        --language markdown \
        -- "${FILE_PATH}" && exit 5

      highlight \
        --out-format="${highlight_format}" \
        --syntax=markdown \
        -- "${FILE_PATH}" && exit 5

      pygmentize \
        -f "${pygmentize_format}" \
        -O "style=${PYGMENTIZE_STYLE}" \
        -- "${FILE_PATH}" && exit 5
      exit 2
      ;;

    # HTML document {{{3
    text/html | application/xhtml+xml)
      ## Preview as text conversion
      w3m -dump "${FILE_PATH}" && exit 5
      lynx -dump -- "${FILE_PATH}" && exit 5
      elinks -dump "${FILE_PATH}" && exit 5
      pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
      ;;

    # Text fallback {{{3
    text/* | \
      application/x-desktop | \
      application/x-yaml | \
      application/xml | \
      application/x-xbel | \
      application/xspf+xml | \
      application/vnd.kde.kxmlguirc | \
      application/x-ksysguard | \
      application/coffeescript | \
      application/nodejs | \
      application/typescript | \
      application/vim | \
      application/x-bash | \
      application/x-cshell | \
      application/x-fish | \
      application/x-shellscript | \
      application/x-zsh)
      # Syntax highlight
      if [[ "$(stat --printf='%s' -- "${FILE_PATH}")" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
        exit 2
      fi

      env COLORTERM=8bit bat \
        --color always \
        --style plain \
        -- "${FILE_PATH}" && exit 5

      highlight \
        --out-format="${highlight_format}" \
        -- "${FILE_PATH}" && exit 5

      pygmentize \
        -f "${pygmentize_format}" \
        -O "style=${PYGMENTIZE_STYLE}" \
        -- "${FILE_PATH}" && exit 5

      exit 2
      ;;

    # Images {{{2
    # SVG image {{{3
    image/svg+xml | image/svg)
      if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
        convert -- "${FILE_PATH}" "${IMAGE_CACHE_PATH}" && exit 6
      fi
      exiftool "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # DjVu image {{{3
    image/vnd.djvu)
      if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
        ddjvu -format=tiff -quality=90 -page=1 -size="${DEFAULT_SIZE}" \
          - "${IMAGE_CACHE_PATH}" <"${FILE_PATH}" &&
          exit 6
      fi
      # Preview as text conversion (requires djvulibre)
      djvutxt "${FILE_PATH}" | fmt -w "${PV_WIDTH}" && exit 5
      exiftool "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # DXF vector image {{{3
    image/vnd.dxf)
      if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
        openscad_image <(echo "import(\"${FILE_PATH}\");") && exit 6
      fi
      exit 1
      ;;

    # Krita document {{{3
    application/x-krita)
      if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
        unzip -p "${FILE_PATH}" preview.png >"${IMAGE_CACHE_PATH}" && exit 6
      fi
      exit 1
      ;;

    # Image fallback {{{3
    image/*)
      if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
        local orientation
        orientation="$(identify -format '%[EXIF:Orientation]\n' -- "${FILE_PATH}")"
        # If orientation data is present and the image actually
        # needs rotating ("1" means no rotation)...
        if [[ -n "$orientation" && "$orientation" != 1 ]]; then
          # ...auto-rotate the image according to the EXIF data.
          convert -- "${FILE_PATH}" -auto-orient "${IMAGE_CACHE_PATH}" && exit 6
        fi

        # `w3mimgdisplay` will be called for all images (unless overriden
        # as above), but might fail for unsupported types.
        exit 7
      fi
      # Preview as text conversion
      # img2txt --gamma=0.6 --width="${PV_WIDTH}" -- "${FILE_PATH}" && exit 4
      exiftool "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Video {{{2
    video/*)
      if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
        # Thumbnail
        ffmpegthumbnailer -i "${FILE_PATH}" -o "${IMAGE_CACHE_PATH}" -s 0 && exit 6
      fi
      mediainfo "${FILE_PATH}" && exit 5
      exiftool "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Audio {{{2
    audio/*)
      if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
        # Thumbnail
        ffmpegthumbnailer -i "${FILE_PATH}" -o "${IMAGE_CACHE_PATH}" -s 0 && exit 6
      fi
      mediainfo "${FILE_PATH}" && exit 5
      exiftool "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Fonts {{{2
    font/*)
      if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
        preview_png="/tmp/$(basename "${IMAGE_CACHE_PATH%.*}").png"
        if fontimage -o "${preview_png}" \
          --pixelsize "120" \
          --fontname \
          --pixelsize "80" \
          --text "  ABCDEFGHIJKLMNOPQRSTUVWXYZ  " \
          --text "  abcdefghijklmnopqrstuvwxyz  " \
          --text "  0123456789.:,;(*!?') ff fl fi ffi ffl  " \
          --text "  The quick brown fox jumps over the lazy dog.  " \
          "${FILE_PATH}"; then
          convert -- "${preview_png}" "${IMAGE_CACHE_PATH}" &&
            rm "${preview_png}" &&
            exit 6
        fi
      fi
      exit 1
      ;;

    # Documents {{{2
    # Microsoft Excel Worksheet {{{3
    application/vnd.ms-excel)
      # Preview as csv conversion
      # xls2csv comes with catdoc:
      #   http://www.wagner.pp.ru/~vitus/software/catdoc/
      xls2csv -- "${FILE_PATH}" && exit 5
      exit 1
      ;;
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)
      # Preview as csv conversion
      # Uses: https://github.com/dilshod/xlsx2csv
      xlsx2csv -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Mobipocket e-book {{{3
    application/x-mobipocket-ebook)
      if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
        # ePub (using https://github.com/marianosimone/epub-thumbnailer)
        epub-thumbnailer "${FILE_PATH}" "${IMAGE_CACHE_PATH}" \
          "${DEFAULT_SIZE%x*}" && exit 6
        ebook-meta --get-cover="${IMAGE_CACHE_PATH}" -- "${FILE_PATH}" \
          >/dev/null && exit 6
      fi
      exit 1
      ;;

    # PDF document {{{3
    application/pdf)
      # Preview as image
      if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
        pdftoppm -f 1 -l 1 \
          -scale-to-x "${DEFAULT_SIZE%x*}" \
          -scale-to-y -1 \
          -singlefile \
          -jpeg -tiffcompression jpeg \
          -- "${FILE_PATH}" "${IMAGE_CACHE_PATH%.*}" &&
          exit 6
      fi
      # Preview as text conversion
      pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - |
        fmt -w "${PV_WIDTH}" && exit 5
      mutool draw -F txt -i -- "${FILE_PATH}" 1-10 |
        fmt -w "${PV_WIDTH}" && exit 5
      exiftool "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # OpenDocument {{{3
    application/vnd.oasis.opendocument.text | \
      application/vnd.oasis.opendocument.spreadsheet | \
      application/vnd.oasis.opendocument.presentation)
      # Preview as text conversion
      odt2txt "${FILE_PATH}" && exit 5
      # Preview as markdown conversion
      pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # DOC, RTF {{{3
    application/msword | application/rtf)
      # Preview as text conversion
      # note: catdoc does not always work for .doc files
      # catdoc: http://www.wagner.pp.ru/~vitus/software/catdoc/
      catdoc -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # EPUB book, FictionBook document {{{3
    application/epub+zip | application/x-fictionbook+xml)
      if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
        # ePub (using https://github.com/marianosimone/epub-thumbnailer)
        epub-thumbnailer "${FILE_PATH}" "${IMAGE_CACHE_PATH}" \
          "${DEFAULT_SIZE%x*}" && exit 6
        ebook-meta --get-cover="${IMAGE_CACHE_PATH}" -- "${FILE_PATH}" \
          >/dev/null && exit 6
      fi
      # Preview as markdown conversion
      pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Archives {{{2
    # Gzip archive {{{3
    application/gzip)
      # pigz is noticeably faster than gzip
      pigz -lv -- "${FILE_PATH}" && exit 5
      gzip -lv -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # RAR archive {{{3
    application/vnd.rar)
      # Avoid password prompt by providing empty password
      unrar lt -p- -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # AR archive {{{3
    application/x-archive)
      ar -tv -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Tar archive {{{3
    application/x-tar | \
      application/x-tarz | \
      application/x-xz-compressed-tar | \
      application/x-lzma-compressed-tar | \
      application/x-lzip-compressed-tar)
      # Using pxz instead of xz didn't really affect performance
      tar --list --file "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Tar archive (bzip-compressed) {{{3
    application/x-bzip-compressed-tar)
      tar --list --use-compress-program=/usr/bin/pbzip2 --file "${FILE_PATH}" && exit 5
      tar --list --file "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Tar archive (Zstandard-compressed) {{{3
    application/x-zstd-compressed-tar)
      tar --list --use-compress-program=/usr/bin/pzstd --file "${FILE_PATH}" && exit 5
      tar --list --file "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Tar archive (gzip-compressed) {{{3
    application/x-compressed-tar)
      tar --list --use-compress-program=/usr/bin/pigz --file "${FILE_PATH}" && exit 5
      tar --list --file "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Lzip archive {{{3
    application/x-lzip)
      lzip -lv -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Zstandard archive {{{3
    application/x-zstd)
      zstd -l -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # 7-zip archive {{{3
    application/x-7z-compressed)
      # Avoid password prompt by providing empty password
      7z l -p -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Zip archive {{{3
    application/zip)
      zipinfo -- "${FILE_PATH}" && exit 5
      unzip -Z -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Other archives {{{3
    application/x-ace | \
      application/x-alz | \
      application/x-arj | \
      application/vnd.ms-cab-compressed | \
      application/x-cpio | \
      application/x-lha | \
      application/x-webarchive | \
      application/vnd.debian.binary-package | \
      application/x-xpinstall | \
      application/x-arc | \
      application/x-java-archive)
      atool --list -- "${FILE_PATH}" && exit 5
      bsdtar --list --file "${FILE_PATH}" && exit 5
      tar --list --file "${FILE_PATH}" && exit 5
      ;;

    # Packages {{{2
    # RPM package {{{3
    application/x-rpm | \
      application/x-source-rpm)
      # Query info on RPM file
      rpm --query --info -- "${FILE_PATH}" && exit 5
      exit 1
      ;;

    # Other application/* {{{2
    # BitTorrent seed file {{{3
    application/x-bittorrent)
      transmission-show -- "${FILE_PATH}" && exit 5
      exit 1
      ;;
  esac
}

# handle_fallback() {{{1
handle_fallback() {
  echo '----- File Type Classification -----' && file --dereference --brief -- "${FILE_PATH}" && exit 5
  exit 1
}

# Other functions {{{1
openscad_image() {
  TMPPNG="$(mktemp -t XXXXXX.png)"
  openscad --colorscheme="${OPENSCAD_COLORSCHEME}" \
    --imgsize="${OPENSCAD_IMGSIZE/x/,}" \
    -o "${TMPPNG}" "${1}"
  mv "${TMPPNG}" "${IMAGE_CACHE_PATH}"
}

# 1}}}

# Main routine

# This actually gets the correct mimetype so we're using it instead of file(1)
MIMETYPE="$(gio info -a standard::content-type -- "${FILE_PATH}" |
  rg '  standard::content-type: ' |
  sd '  standard::content-type: ' '')"
# case "${MIMETYPE}" in
#   text/plain | application/octet-stream)
#     MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
#     ;;
# esac
# if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
#   handle_image "${MIMETYPE}"
# fi
handle_extension
handle_mime "${MIMETYPE}"
handle_fallback

exit 1

# vim:ft=sh fdm=marker
