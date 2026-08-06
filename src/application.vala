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

        }

        protected override void activate ()
        {
            var win = this.active_window;
            if (win == null) {
                win = new Example.MainWindow (this);
            }
            win.present ();
        }

    }
}
