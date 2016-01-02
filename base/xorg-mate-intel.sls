/lib64:
  file.recurse:
    - source: salt://lib64
    - include_empty: True

/lib64/udev/display.sh:
  file.managed:
    - source: salt://lib64/udev/display.sh
    - mode: 755

/etc/portage/make.profile:
  file.symlink:
    - target: ../../usr/portage/profiles/default/linux/amd64/13.0
