pkg_name="icewatch"
pkg_version="3.0.0"
pkg_origin="uafgina"
pkg_maintainer="UAF GINA <support+habitat@gina.alaska.edu>"
pkg_license=('MIT')
pkg_source="${pkg_name}-${pkg_version}.tar.bz2"
pkg_deps=(
  core/bundler
  core/cacerts
  core/glibc
  core/libffi
  core/libyaml
  core/libxml2
  core/libxslt
  core/openssl
  core/postgresql
  core/redis
  core/ruby
  core/zlib
  core/imagemagick
)
pkg_build_deps=(
  core/coreutils
  core/gcc
  core/make
  core/git
  core/postgresql
  core/which
  core/pkg-config
  core/imagemagick
)

pkg_bin_dirs=(bin)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib)
pkg_expose=(9292)

do_download() {
  export GIT_SSL_CAINFO="$(pkg_path_for core/cacerts)/ssl/certs/cacert.pem"
  if [[ ! -d icewatch ]]; then
    git clone https://github.com/gina-alaska/icewatch
  fi
  pushd icewatch
  git checkout $pkg_version
  popd
  tar -cjvf $HAB_CACHE_SRC_PATH/${pkg_name}-${pkg_version}.tar.bz2 \
      --transform "s,^\./icewatch,icewatch-${pkg_version}," ./icewatch \
      --exclude icewatch/.git --exclude icewatch/spec
  pkg_shasum=$(trim $(sha256sum $HAB_CACHE_SRC_PATH/${pkg_filename} | cut -d " " -f 1))
}

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

  bundle install --jobs 2 --retry 5 --path vendor/bundle --binstubs --without development test
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
