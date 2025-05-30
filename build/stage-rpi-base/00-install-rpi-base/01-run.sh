function info() {
  [[ "$CI" = true ]] && echo "::group::$*" || >&2 echo "$*"
}

function endinfo() {
  [[ "$CI" = true ]] && echo "::endgroup::" || true
}

info "updating the login screen and message of the day"
export VERSION
rm ${ROOTFS_DIR}/etc/motd
rm ${ROOTFS_DIR}/etc/update-motd.d/10-uname
envsubst < files/etc/update-motd.d/10-hello.template > ${ROOTFS_DIR}/etc/update-motd.d/10-hello
chmod a+x ${ROOTFS_DIR}/etc/update-motd.d/10-hello

rm ${ROOTFS_DIR}/etc/issue
envsubst < files/etc/issue.template > ${ROOTFS_DIR}/etc/issue
endinfo

info "expire default password to force change on first login"
on_chroot << EOF
  chage --lastday 0 pi
EOF

install files/home/pi/disable-ssh-password-auth "${ROOTFS_DIR}/home/pi/"
endinfo

info "install k3s"
curl -sfL https://get.k3s.io | sh -
endinfo