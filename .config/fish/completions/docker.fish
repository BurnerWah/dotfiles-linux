if [ -f /etc/containers/nodocker -o -f /usr/lib/tmpfiles.d/podman-docker.conf ]
    complete -c docker -w podman
end
