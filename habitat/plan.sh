pkg_name="icewatch"
pkg_version="3.1.2"
pkg_origin="uafgina"
pkg_maintainer="UAF GINA <support+habitat@gina.alaska.edu>"
pkg_license=('MIT')
# pkg_source="https://github.com/gina-alaska/${pkg_name}/archive/${pkg_version}.tar.gz"
# pkg_shasum="ed3042c3a1f570a62024490cb5c71dd310af86b08acc90e9681d9367d33ed3ab"

pkg_deps=(
  core/cacerts
  uafgina/imagemagick
  core/sqlite
  core/gcc-libs
)

pkg_build_deps=(
  core/ruby/2.3.4/20170519004213
)

pkg_bin_dirs=(bin)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib)
pkg_expose=(4000)

pkg_scaffolding=uafgina/scaffolding-ruby

declare -A scaffolding_env

scaffolding_env[ICEWATCH_GOOGLE_KEY]="{{cfg.google_key}}"
scaffolding_env[ICEWATCH_GOOGLE_SECRET]="{{cfg.google_secret}}"

do_prepare() {
  do_default_prepare

  # needed to do asset precompile
  export SSL_CERT_FILE="$(pkg_path_for core/cacerts)/ssl/certs/cacert.pem"
  # needed for running in production
  scaffolding_env[SSL_CERT_FILE]="$(pkg_path_for core/cacerts)/ssl/certs/cacert.pem"
}
