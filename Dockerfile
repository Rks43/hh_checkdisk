FROM ubuntu:22.04
COPY disk_check /disk_check
CMD ["/disk_check"]
