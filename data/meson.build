configure_file(
  input: 'io.github.agustingv.example.desktop.in',
  output: 'io.github.agustingv.example.desktop',
  copy: true,
  install: true,
  install_dir: get_option('datadir') / 'applications',
)

install_data(
  'io.github.agustingv.example.gschema.xml',
  install_dir: get_option('datadir') / 'glib-2.0' / 'schemas',
)

gnome.post_install(
  glib_compile_schemas: true,
)

configure_file(
  input: 'io.github.agustingv.example.metainfo.xml.in',
  output: 'io.github.agustingv.example.metainfo.xml',
  copy: true,
  install: true,
  install_dir: get_option('datadir') / 'metainfo',
)

configure_file(
  input: 'io.github.agustingv.example.service.in',
  output: 'io.github.agustingv.example.service',
  configuration: {
    'bindir': get_option('prefix') / get_option('bindir'),
  },
  install: true,
  install_dir: get_option('datadir') / 'dbus-1' / 'services',
)
