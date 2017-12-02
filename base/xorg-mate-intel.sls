/lib64:
  file.recurse:
    - source: salt://lib64
    - include_empty: True

/lib64/udev/display.sh:
  file.managed:
    - source: salt://lib64/udev/display.sh
    - mode: 755

/lib64/udev/rules.d/95-upower-csr.rules:
  file.patch:
    - source: salt://patches/95-upower-csr.rules.patch
    - hash: md5=34d876f4530e3c3de86d94757e38ee7d

/usr:
  file.recurse:
    - source: salt://usr
    - include_empty: True

/etc/portage/make.profile:
  file.symlink:
    - target: ../../usr/portage/profiles/default/linux/amd64/17.0
