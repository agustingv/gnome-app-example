namespace Example
{
	public class HttpClient : GLib.Object
	{
		private SoupExample.Session session;

		public HttpClient ()
		{
			session = new SoupExample.Session ();
		}

		public string fetch (string url) throws GLib.Error
		{
			var msg = new SoupExample.Message ("GET", url);
			var bytes = session.send_and_read (msg, null);

			if (msg.status != 200) {
				throw new GLib.IOError.FAILED ("HTTP %u fetching %s", msg.status, url);
			}

			return (string) bytes.get_data ();
		}
	}
}
