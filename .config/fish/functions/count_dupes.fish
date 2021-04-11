# Defined interactively
function count_dupes --description 'Count duplicate lines in a stream'
    sort | uniq -c | sort -n $argv
end
