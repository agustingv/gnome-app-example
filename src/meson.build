resources = gnome.compile_resources(
  'example-resources',
  '../data/example.gresource.xml',
  source_dir: '../data',
  c_name: 'example',
)

config_vala = configure_file(
  input:  'Application/config.vala.in',
  output: 'config.vala',
  configuration: {
    'GETTEXT_PACKAGE': meson.project_name(),
    'LOCALE_DIR': get_option('prefix') / get_option('localedir'),
  },
)

sources = files(
  'Application/Main.vala',
  'Application/Application.vala',
  'Model/Item.vala',
  'Services/Services.vala',
  'Services/HttpClient.vala',
  'Services/XmlValidator.vala',
  'Services/RssFeedParser.vala',
  'Services/ImplRemoteFeedService.vala',
  'Repository/Repository.vala',
  'Repository/DummyRepository.vala',
  'Repository/RemoteFeedRepository.vala',
  'ViewModel/ItemListViewModel.vala',
  'View/MainWindow.vala',
  'View/ItemRow.vala',
  '../vapi/soup-example.vapi'
) + [config_vala]

dependencies = [
  dependency('gee-0.8'),
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
  dependency('gmodule-2.0'),
  dependency('libsoup-3.0'),
  dependency('libxml-2.0'),
  meson.get_compiler('c').find_library('m', required: false),
]

executable('example',
  sources + resources,
  dependencies: dependencies,
  vala_args: ['--target-glib=2.76', '--pkg=gmodule-2.0'],
  install: true,
)
