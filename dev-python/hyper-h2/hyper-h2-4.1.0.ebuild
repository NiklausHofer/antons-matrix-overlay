# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="HTTP/2 State-Machine based protocol implementation"
HOMEPAGE="https://python-hyper.org/h2/en/stable/ https://pypi.org/project/h2/"
SRC_URI="https://github.com/python-hyper/h2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/hyperframe-6.0[${PYTHON_USEDEP}]
	<dev-python/hyperframe-7[${PYTHON_USEDEP}]
	>=dev-python/hpack-4.0[${PYTHON_USEDEP}]
	<dev-python/hpack-5[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"
S="${WORKDIR}/h2-${PV}"

distutils_enable_tests pytest

python_test() {
	local deselect=()
	[[ ${EPYTHON} == python3.10 ]] && deselect+=(
		# these rely on fixed string repr() and fail because enum repr
		# changed in py3.10
		test/test_basic_logic.py::TestBasicServer::test_stream_repr
		test/test_events.py::TestEventReprs::test_remotesettingschanged_repr
		test/test_events.py::TestEventReprs::test_streamreset_repr
		test/test_events.py::TestEventReprs::test_settingsacknowledged_repr
		test/test_events.py::TestEventReprs::test_connectionterminated_repr
	)

	epytest ${deselect[@]/#/--deselect }
}
