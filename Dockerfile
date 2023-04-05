FROM alpine:latest
# kpartx is in multipath-tools
RUN apk add --no-cache xfsprogs multipath-tools parted tar losetup gawk grep

# Set work directory
WORKDIR /_out

COPY edit_kernel_params.sh /image-edit/edit_kernel_params.sh
ENTRYPOINT ["/image-edit/edit_kernel_params.sh"]