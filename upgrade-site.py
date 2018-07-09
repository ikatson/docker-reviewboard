#!/usr/bin/env python

import sys
import subprocess
import semver
import reviewboard


def main(version_file, site_folder):
    running_version = reviewboard.get_version_string()

    try:
        with open(version_file) as f:
            previous_version = f.readline().strip()
    except IOError:
        previous_version = "0.0.0"

    if semver.compare(running_version, previous_version) == 1:
        print("ReviewBoard upgrade detected, performing rb-site upgrade")
        subprocess.check_call(["rb-site", "upgrade", site_folder])
        with open(version_file, 'w') as f:
            f.write(running_version)


if __name__ == "__main__":
    main(*sys.argv[1:])
