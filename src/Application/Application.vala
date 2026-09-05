namespace Example
{

    public class Application : Adw.Application
    {

        public Application ()
        {
            Object (
                application_id: "io.github.agustingv.example",
                flags: ApplicationFlags.DEFAULT_FLAGS
            );
        }

        construct
        {
            var about_action = new SimpleAction ("about", null);
            about_action.activate.connect (showAbout);
            add_action (about_action);

            set_accels_for_action ("app.about", { "<Ctrl>A" });
        }

        protected override void startup ()
        {
            base.startup ();

            var provider = new Gtk.CssProvider ();
            provider.load_from_resource ("/io/github/agustingv/example/ui/css/style.css");
            //TODO: revisar StyleContext deprecated since Gtk 4.10
            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (),
                provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }

        protected override void activate ()
        {
            var win = this.active_window;
            if (win == null) {
                win = new Example.MainWindow (this);
            }
            win.present ();
        }

        private void showAbout () 
        {
            var dialog = new Adw.AboutDialog ();
            dialog.application_name = "Example";
            dialog.application_icon = "io.github.agustingv.example";
            dialog.version          = "1.0.0";
            dialog.developer_name   = "Example Contributors";
            dialog.license_type     = Gtk.License.GPL_3_0;
            dialog.website          = "https://github.com/agustingv/example";
            dialog.issue_url        = "https://github.com/agustingv/example/issues";
            dialog.comments         = _("A simple example application");
            dialog.present (active_window);
        }       

    }
}
