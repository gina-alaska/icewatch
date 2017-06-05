# Copied from core/nginx until I can figure out a good way to "wrap" services and provide
#  our own config

pkg_name="icewatch-proxy"
pkg_version="2.0.0"
pkg_origin="uafgina"
pkg_maintainer="UAF GINA <support+habitat@gina.alaska.edu>"
pkg_deps=(core/nginx core/curl)
pkg_build_deps=(core/git)
pkg_svc_run="nginx -c ${pkg_svc_config_path}/nginx.conf"
pkg_svc_user="root"
pkg_svc_group="root"
pkg_exports=(
  [port]=http.listen.port
)
pkg_binds_optional=(
  [app]="port"
)
pkg_exposes=(port)

do_build() {
  return 0
}

do_download() {
  return 0
}

do_install() {
  return 0
}

do_prepare() {
  return 0
}

do_unpack() {
  return 0
}
