#!/bin/bash

# version of your package
VERSION_qca=2.1.3

# dependencies of this recipe
DEPS_qca=(openssl)

# url of the package
# URL_qca=http://delta.affinix.com/download/qca/2.0/qca-${VERSION_qca}.tar.gz
# URL_qca=http://quickgit.kde.org/?p=qca.git&a=snapshot&h=4f966b0217c10b6fd3c12caf7d2467759fbec7f7&fmt=tgz
#URL_qca=https://github.com/KDE/qca/archive/v${VERSION_qca}.tar.gz
URL_qca=https://github.com/KDE/qca/archive/32343842d359a60e3619f97aac983d587f6eca16.zip

# md5 of the package
MD5_qca=180212f7d8d9290b4eca19717b4809f6

# default build path
BUILD_qca=$BUILD_PATH/qca/$(get_directory $URL_qca)

# default recipe path
RECIPE_qca=$RECIPES_PATH/qca

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qca() {
  cd $BUILD_qca
  # check marker
  if [ -f .patched ]; then
    return
  fi

  try patch --verbose --forward -p1 < $RECIPE_qca/patches/qca_qio.patch
  try patch --verbose --forward -p1 < $RECIPE_qca/patches/qca_console.patch
  try patch --verbose --forward -p1 < $RECIPE_qca/patches/cxx11.patch
  try patch --verbose --forward -p1 < $RECIPE_qca/patches/No-setuid-on-Android.patch

  touch .patched
}

function shouldbuild_qca() {
 # If lib is newer than the sourcecode skip build
 if [ $BUILD_qca/build-$ARCH/lib/libqca-qt5.so -nt $BUILD_qca/.patched ]; then
  DO_BUILD=0
 fi
}

# function called to build the source code
function build_qca() {
 try mkdir -p $BUILD_qca/build-$ARCH
 try cd $BUILD_qca/build-$ARCH

	push_arm

 # configure
 try $CMAKECMD \
  -DQT4_BUILD=OFF \
  -DQCA_SUFFIX=qt5 \
  -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
  -DBUILD_TESTS=OFF \
  -DBUILD_TOOLS=OFF \
  -DWITH_nss_PLUGIN=OFF \
  -DWITH_pkcs11_PLUGIN=OFF \
  -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=TRUE \
  $BUILD_qca
 # try $MAKESMP
 try $MAKESMP install

	pop_arm
}

# function called after all the compile have been done
function postbuild_qca() {
	true
}


# -DBUILD_PLUGINS=auto
# -DBUILD_SHARED_LIBS=ON
# -DBUILD_TESTS=ON
# -DBUILD_TOOLS=ON
# -DCMAKE_BUILD_TYPE=Release
# -DCMAKE_INSTALL_PREFIX=/usr/local
# -DDEVELOPER_MODE=OFF
# -DPKG_CONFIG_EXECUTABLE=/usr/bin/pkg-config \
# -DPKGCONFIG_INSTALL_PREFIX=/usr/lib/x86_64-linux-gnu/pkgconfig
# -DQCA_BINARY_INSTALL_DIR=/usr/lib/x86_64-linux-gnu/qt5/bin
# -DQCA_DOC_INSTALL_DIR=/usr/share/qt5/doc/html/qca
# -DQCA_FEATURE_INSTALL_DIR=/usr/lib/x86_64-linux-gnu/qt5/mkspecs/features
# -DQCA_INCLUDE_INSTALL_DIR=/usr/include/x86_64-linux-gnu/qt5
# -DQCA_LIBRARY_INSTALL_DIR=/usr/lib/x86_64-linux-gnu
# -DQCA_MAN_INSTALL_DIR=/usr/share/qt5/man
# -DQCA_PLUGINS_INSTALL_DIR=/usr/lib/x86_64-linux-gnu/qt5/plugins
# -DQCA_PREFIX_INSTALL_DIR=/usr
# -DQCA_PRIVATE_INCLUDE_INSTALL_DI=/usr/include/x86_64-linux-gnu/qt5
# -DQCA_SUFFIX
# -DQT4_BUILD=OFF
# -DUSE_RELATIVE_PATHS=OFF
# -DWITH_botan_PLUGIN
# -DWITH_cyrus-sasl_PLUGIN
# -DWITH_gcrypt_PLUGIN
# -DWITH_gnupg_PLUGIN
# -DWITH_logger_PLUGIN
# -DWITH_nss_PLUGIN
# -DWITH_ossl_PLUGIN
# -DWITH_pkcs11_PLUGIN
# -DWITH_softstore_PLUGIN
