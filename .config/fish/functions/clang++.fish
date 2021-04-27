set -l desc "The Clang C, C++, and Objective-C compiler"
if command -qs clang++
    if [ (basename (readlink (command -s clang++))) != ccache ]
        if command -qs sccache
            function clang++ -d $desc
                command sccache clang++ $argv
            end
        else if command -qs ccache
            function clang++ -d $desc
                command ccache clang++ $argv
            end
        end
    end
end
