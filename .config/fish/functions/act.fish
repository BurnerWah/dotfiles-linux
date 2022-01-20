function act
    set -lx DOCKER_HOST "unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    command act $argv
end
