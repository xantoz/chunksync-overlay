EAPI=7

inherit toolchain-funcs

DESCRIPTION="chunkfs - mount arbitrary files via FUSE as a tree of chunk files"
HOMEPAGE="https://chunkfs.florz.de/"
SRC_URI="https://chunkfs.florz.de/chunkfs_0.7.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="amd64"

# perl for pod2man
BDEPEND="dev-lang/perl"

DEPEND=">=sys-fs/fuse-2.5"
RDEPEND="${DEPEND}"

PATCHES="${FILESDIR}/0001-Fix-printf-related-build-warnings.patch"

src_prepare() {
	sed -i -e '/install:/a\' -e '\tmkdir -p ${DESTDIR}${PREFIX}/bin/ ${DESTDIR}${PREFIX}/share/man/man1/' Makefile
	# stop portage complaining about pre-compressed man pages
	sed -i -e 's/| gzip > $@/> $@/' -e "s/${PN}.1.gz/${PN}.1/g" Makefile
	# stop portage complaining about pre-stripped binaries
	sed -i -e 's/LDFLAGS=-s/LDFLAGS=/' Makefile
	# stop portage complaining about unexpected paths
	sed -i -e 's|share/doc/chunkfs/|share/doc/${PF}/|g' Makefile

	[[ -n ${PATCHES} ]] && eapply ${PATCHES}
	eapply_user
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr CC="$(tc-getCC)" install
}
