if command -qs swig
    and command -qs ccache-swig
    function swig -d "Simplified Wrapper and Interface Generator"
        command ccache-swig swig $argv
    end
end
