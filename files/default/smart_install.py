#!/usr/bin/env python

# Smart Install
# Nitzan Raz 2016
# GPLv2

# Used to determine whether pip wants to install/upgrade a certain requirement row
# Accepts requirement row in ARGV
# Return the following:
# OUTPUT | install | upgrade |
# 0      | F       | F       |
# 1      | F       | T       |
# 2      | T       | T       |

# Exit code stays "authentic" to indicate errors

import sys
req_row = sys.argv[1]

from pip.req import InstallRequirement
req = InstallRequirement.from_line(req_row)
exists = req.check_if_exists()
satisfied = req.satisfied_by is not None
if exists:
    if satisfied:
        ret=0
    else:
        ret=1
else:
    ret=2

print ret
