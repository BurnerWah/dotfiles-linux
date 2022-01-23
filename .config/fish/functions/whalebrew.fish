function whalebrew
    # This ensures whalebrew uses rootless docker instead of root docker
    # The other environment variables needed are in an environment.d file
    set -lx DOCKER_HOST "unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    command whalebrew $argv
end
