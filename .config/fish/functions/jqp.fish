if [ (command -s jq prettier bat tput | count) = 4 ]
  function jqp -w jq -d "Command-line JSON processor (pretty printer)"
    command jq -c $argv \
       |  prettier --parser json --print-width (tput cols) \
       |  bat --language=json --paging=never --color=always --style=plain
  end
end
