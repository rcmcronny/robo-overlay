# Copyright 2013-2014 iXit Group
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="47"
K_DEBLOB_AVAILABLE="0"

inherit kernel-2
detect_version
detect_arch

MPTCP_FILE="mptcp-v4.4-7a8e371e4f58.patch"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
HOMEPAGE="http://multipath-tcp.org/patches/ http://dev.gentoo.org/~mpagano/genpatches http://multipath-tcp.org"
IUSE="deblob experimental +mptcp"

DESCRIPTION="Hybrid sources including the Gentoo patchset, Multipath support for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
	http://multipath-tcp.org/patches/${MPTCP_FILE}
	http://boesger.de/mptcp/${MPTCP_FILE}
"
src_prepare() {
	if [ ! -d "$WORKDIR/net/mptcp" ]; then
		use mptcp && epatch "${DISTDIR}/${MPTCP_FILE}"
		#use mptcp && epatch "${FILESDIR}/${MPTCP_FILE}"
		ver=${MPTCP_FILE//\.patch/}
		version=${ver//mptcp-/}
		#versionstring=`cat net/mptcp/mptcp_ctrl.c | grep pr_info  | grep "release" | tr -d 'pr_info(' | tr -d '");' | xargs`
		versionstring=`cat net/mptcp/mptcp_ctrl.c | grep pr_info  | grep "release" | sed -e 's/pr_info(//g' | sed -e 's/);//g' | sed -e 's/"//g' | awk '{gsub(/^ +| +$/,"")} {print $0}' | xargs`
		versionstring="$versionstring ($version)"

		einfo "changing version info to ${versionstring}"
		sed -i.bak -e "s/pr_info(\"MPTCP:.* release .*\");/pr_info(\"${versionstring}\");/g" net/mptcp/mptcp_ctrl.c || ewarn "warn: version change failed"
	else
		einfo "MPTCP seems to be included, skipping patch"
	fi
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
