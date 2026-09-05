namespace Example {

    [GtkTemplate (ui = "/io/github/agustingv/example/ui/item-row.ui")]
    public class ItemRow : Gtk.Box {

        public Item item { get; construct; }

        public ItemRow (Item item)
        {
            Object(item: item);
        }

        construct
        {
            if (item.link != "") {
                set_cursor_from_name ("pointer");

                var click = new Gtk.GestureClick ();
                click.released.connect (open_link);
                add_controller (click);
            }
        }

        private void open_link ()
        {
            var launcher = new Gtk.UriLauncher (item.link);
            launcher.launch.begin (get_root () as Gtk.Window, null, (obj, res) => {
                try {
                    launcher.launch.end (res);
                } catch (Error e) {
                    warning ("Failed to open link: %s", e.message);
                }
            });
        }

    }
}
