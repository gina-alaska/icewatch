pkg_name="icewatch"
pkg_version="3.0.0"
pkg_origin="uafgina"
pkg_maintainer="UAF GINA <support+habitat@gina.alaska.edu>"
pkg_license=('MIT')
pkg_source="https://github.com/gina-alaska/${pkg_name}/archive/${pkg_version}.tar.gz"
pkg_shasum="22ca108c2bcb9e544ec25898b71386537fe18f4e3f46cd13f25a5225e12632bd"

pkg_deps=(
  core/bundler/1.11.2/20160708181052
  core/cacerts/2016.04.20/20160612081125
  core/glibc/2.22/20160612063629
  core/libffi/3.2.1/20160621150608
  core/libyaml/0.1.6/20160612150821
  core/libxml2/2.9.2/20160612150903
  core/libxslt/1.1.28/20160707065627
  core/openssl/1.0.2h/20160708160802
  core/postgresql/9.5.3/20160708180214
  core/redis/3.0.7/20160614001713
  core/ruby/2.3.1/20160708180653
  core/zlib/1.2.8/20160612064520
  core/imagemagick/6.9.2-10/20160715022522
  core/node
)
pkg_build_deps=(
  core/coreutils/8.25/20160716003322
  core/gcc/5.2.0/20160612064854
  core/make/4.1/20160612080650
  core/git/2.7.4/20160726200149
  core/postgresql/9.5.3/20160708180214
  core/which/2.21/20160612155441
  core/pkg-config/0.29/20160612075046
  core/imagemagick/6.9.2-10/20160715022522
  core/node
  core/sqlite
)

pkg_bin_dirs=(bin)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib)
pkg_expose=(9292)

do_prepare() {
  build_line "Setting link for /usr/bin/env to 'coreutils'"
  [[ ! -f /usr/bin/env ]] && ln -s $(pkg_path_for coreutils)/bin/env /usr/bin/env

  build_line "Setting link for /usr/bin/which to 'which'"
  [[ ! -f /usr/bin/which ]] && ln -s $(pkg_path_for which)/bin/which /usr/bin/which

  build_line "Setting link for /usr/bin/pkg-config to 'pkg-config'"
  [[ ! -f /usr/bin/which ]] && ln -s $(pkg_path_for pkg-config)/bin/pkg-config /usr/bin/pkg-config

  return 0
}

do_build() {
  export CPPFLAGS="${CPPFLAGS} ${CFLAGS}"
  export GIT_SSL_CAINFO="$(pkg_path_for core/cacerts)/ssl/certs/cacert.pem"
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pkg_path_for core/gcc-libs)/lib
  
  local _bundler_dir=$(pkg_path_for bundler)
  local _libxml2_dir=$(pkg_path_for libxml2)
  local _libxslt_dir=$(pkg_path_for libxslt)
  local _postgresql_dir=$(pkg_path_for postgresql)
  local _imagemagick_dir=$(pkg_path_for imagemagick)
  local _pg_config=${_postgresql_dir}/bin/pg_config
  local _magickconfig=${_imagemagick_dir}/bin/Magick-config
  local _zlib_dir=$(pkg_path_for zlib)

  export GEM_HOME=${pkg_path}/vendor/bundler
  export GEM_PATH=${_bundler_dir}:${GEM_HOME}
  export PKG_CONFIG_PATH=$(pkg_path_for imagemagick)/lib/pkgconfig

  # don't let bundler split up the nokogiri config string (it breaks
  # the build), so specify it as an env var instead
  # -- Thanks JTimberman for writing this!
  export NOKOGIRI_CONFIG="--use-system-libraries --with-zlib-dir=${_zlib_dir} --with-xslt-dir=${_libxslt_dir} --with-xml2-include=${_libxml2_dir}/include/libxml2 --with-xml2-lib=${_libxml2_dir}/lib"
  bundle config build.nokogiri '${NOKOGIRI_CONFIG}'
  build_line "Setting pg_config=${_pg_config}"
  bundle config build.pg --with-pg-config=$_pg_config

  if [[ -z "`grep 'gem .*tzinfo-data.*' Gemfile`" ]]; then
    echo 'gem "tzinfo-data"' >> Gemfile
  fi

  npm install bower  
  bundle install --jobs 2 --retry 5 --path vendor/bundle --binstubs --without development test

  build_line "Creating tmp"
  rake tmp:create
  build_line "Precompiling Assets"
  rake as
}

do_install() {
  cp -R . ${pkg_prefix}/dist

  for binstub in ${pkg_prefix}/dist/bin/*; do
    build_line "Setting shebang for ${binstub} to 'ruby'"
    [[ -f $binstub  ]] && sed -e "s#/usr/bin/env ruby#$(pkg_path_for ruby)/bin/ruby#" -i $binstub
  done

  if [[ `readlink /usr/bin/env` = "$(pkg_path_for coreutils)/bin/env" ]]; then
    build_line "Removing the symlink we created for '/usr/bin/env'"
    rm /usr/bin/env
  fi

  if [[ `readlink /usr/bin/which` = "$(pkg_path_for coreutils)/bin/which" ]]; then
    build_line "Removing the symlink we created for '/usr/bin/which'"
    rm /usr/bin/which
  fi

  if [[ `readlink /usr/bin/pkg-config` = "$(pkg_path_for pkg-config)/bin/pkg-config" ]]; then
    build_line "Removing the symlink we created for '/usr/bin/pkg-config'"
    rm /usr/bin/pkg-config
  fi
 }
