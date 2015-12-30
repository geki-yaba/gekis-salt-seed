/etc:
  file.recurse:
    - source: salt://etc
    - include_empty: True

/etc/mtab:
  file.symlink:
    - target: /proc/self/mounts

/etc/portage/make.profile:
  file.symlink:
    - target: ../../usr/portage/profiles/default/linux/amd64/13.0

/etc/cron.daily/salt:
  file.managed:
    - mode: 755

/lib64:
  file.recurse:
    - source: salt://lib64
    - include_empty: True

/lib64/udev/display.sh:
  file.managed:
    - mode: 755

/usr/portage/distfiles:
  file.directory:
    - makedirs: True

emerge-depclean:
  cmd.run:
    - name: emerge --depclean

eclean-pkg-deep:
  cmd.run:
    - name: eclean-pkg --deep
