# Copyright 2013-2014 iXit Group
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="55"
K_DEBLOB_AVAILABLE="0"
inherit kernel-2
detect_version
detect_arch

MPTCP_FILE="mptcp-v4.19-dc1745e03e12.patch"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
HOMEPAGE="http://multipath-tcp.org/patches/ http://dev.gentoo.org/~mpagano/genpatches http://multipath-tcp.org"
IUSE="deblob experimental +mptcp"

DESCRIPTION="MultiPath-TCP sources including the Gentoo patchset, Multipath support for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
	http://multipath-tcp.org/patches/${MPTCP_FILE}
"
src_prepare() {
	if [ ! -d "$WORKDIR/net/mptcp" ]; then
		use mptcp && epatch "${DISTDIR}/${MPTCP_FILE}"
		ver=${MPTCP_FILE//\.patch/}
		version=${ver//mptcp-/}
		einfo "changing version info to ${version}"
		sed -i.bak -e "s/pr_info(\"MPTCP:.* release .*\");/pr_info(\"MPTCP: ${version}\");/g" net/mptcp/mptcp_ctrl.c || ewarn "warn: version change failed"
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
