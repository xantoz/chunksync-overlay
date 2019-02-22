EAPI=7

inherit toolchain-funcs

DESCRIPTION="chunksync - space-efficient incremental (remote) backups of large files"
HOMEPAGE="https://chunksync.florz.de/"
SRC_URI="https://chunksync.florz.de/chunksync_0.4.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="amd64"

# perl for pod2man
BDEPEND="dev-lang/perl"

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e '/install:/a\' -e '\tmkdir -p ${DESTDIR}${PREFIX}/bin/ ${DESTDIR}${PREFIX}/share/man/man1/' Makefile
	# stop portage complaining about pre-compressed man pages
	sed -i -e 's/| gzip > $@/> $@/' -e "s/${PN}.1.gz/${PN}.1/g" Makefile
	# stop portage complaining about pre-stripped binaries
	sed -i -e 's/LDFLAGS=-s/LDFLAGS=/' Makefile

	[[ -n ${PATCHES} ]] && eapply ${PATCHES}
	eapply_user
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr CC="$(tc-getCC)" install
}
