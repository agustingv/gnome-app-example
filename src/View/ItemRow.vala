namespace Example {

    [GtkTemplate (ui = "/io/github/agustingv/example/ui/item-row.ui")]
    public class ItemRow : Gtk.Box {

        [GtkChild] unowned Gtk.Label title_label;
        [GtkChild] unowned Gtk.Label description_label;

        public Item item { get; construct; }

        public ItemRow (Item item)
        {
            Object(item: item);
        }

        construct
        {
            title_label.set_text (HtmlMarkup.to_plain_text (item.title));
            description_label.set_markup (HtmlMarkup.to_pango_markup (item.description));
        }

    }
}
