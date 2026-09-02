namespace Example {

    [GtkTemplate (ui = "/io/github/agustingv/example/ui/item-row.ui")]
    public class ItemRow : Gtk.Box {

        public Item item { get; construct; }

        public ItemRow (Item item)
        {
            Object(item: item);
        }
        
    }
}
