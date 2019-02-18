#!/bin/bash

set -e

source version.sh

WORK_DIR=build/

if [ -z $SKIP_RESET ]; then
	rm -rf ${WORK_DIR}

	mkdir -p ${WORK_DIR}
fi

pushd ${WORK_DIR}

if [ -z $SKIP_RESET ]; then
	PKG_STRING=${PKG_NAME}_${PKG_SUFFIX}
	URL_PREFIX=http://http.debian.net/debian/pool/main/${PKG_NAME:0:1}/${PKG_NAME}

	wget ${URL_PREFIX}/${PKG_STRING}.dsc
	wget ${URL_PREFIX}/${PKG_NAME}_${PKG_VERSION}.orig.${ORIG_EXT}
	wget ${URL_PREFIX}/${PKG_STRING}.debian.${DEBIAN_EXT}

	dpkg-source -x ${PKG_STRING}.dsc

	[ -f ../../rules.patch ] && patch squid-${PKG_VERSION}/debian/rules < ../../rules.patch
fi

cd ${PKG_NAME}-${PKG_VERSION}
DEB_BUILD_OPTIONS=noautodbgsym dpkg-buildpackage -rfakeroot -b -j${NPROC}

popd
