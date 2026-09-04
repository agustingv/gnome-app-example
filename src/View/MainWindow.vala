namespace Example {

    [GtkTemplate (ui = "/io/github/agustingv/example/ui/main-window.ui")]
    public class MainWindow : Adw.ApplicationWindow {

        [GtkChild] unowned Gtk.ListBox item_list;

        private ItemListViewModel view_model = new ItemListViewModel ();

        public MainWindow (Gtk.Application app) {
            Object (application: app);
        }

        construct
        {
            foreach (var item in view_model.items)
            {
                item_list.insert(new ItemRow (item), -1);
            }
        }

    }
}
