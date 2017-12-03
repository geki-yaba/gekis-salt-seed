/etc:
  file.recurse:
    - source: salt://etc
    - include_empty: True

/etc/cron.daily/salt:
  file.managed:
    - source: salt://etc/cron.daily/salt
    - mode: 755

/etc/portage/update/client:
  file.managed:
    - source: salt://etc/portage/update/client
    - mode: 750
    - makedirs: True

/etc/mtab:
  file.symlink:
    - target: /proc/self/mounts

/usr/portage/distfiles:
  file.directory:
    - makedirs: True

eupdate:
  cmd.run:
    - name: /etc/portage/update/client
