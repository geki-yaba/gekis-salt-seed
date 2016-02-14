/etc:
  file.recurse:
    - source: salt://etc
    - include_empty: True

/etc/cron.daily/salt:
  file.managed:
    - source: salt://etc/cron.daily/salt
    - mode: 755

/etc/mtab:
  file.symlink:
    - target: /proc/self/mounts

/usr/portage/distfiles:
  file.directory:
    - makedirs: True

emaint:
  cmd.run:
    - name: emaint sync -a

emerge-depclean:
  cmd.run:
    - name: emerge --depclean

eclean-pkg-deep:
  cmd.run:
    - name: eclean-pkg --deep
