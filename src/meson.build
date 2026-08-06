resources = gnome.compile_resources(
  'example-resources',
  '../data/example.gresource.xml',
  source_dir: '../data',
  c_name: 'example',
)

config_vala = configure_file(
  input:  'config.vala.in',
  output: 'config.vala',
  configuration: {
    'GETTEXT_PACKAGE': meson.project_name(),
    'LOCALE_DIR': get_option('prefix') / get_option('localedir'),
  },
)

sources = files(
  'main.vala',
  'application.vala',
  'main-window.vala'
) + [config_vala]

dependencies = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('gmodule-2.0'),
  meson.get_compiler('c').find_library('m', required: false),
]

executable('example',
  sources + resources,
  dependencies: dependencies,
  vala_args: ['--target-glib=2.76', '--pkg=gmodule-2.0'],
  install: true,
)
