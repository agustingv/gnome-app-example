namespace Example {

    [GtkTemplate (ui = "/io/github/agustingv/example/ui/main-window.ui")]
    public class MainWindow : Adw.ApplicationWindow {

        public MainWindow (Gtk.Application app) {
            Object (application: app);
        }

        construct
        {
        }

    }
}
