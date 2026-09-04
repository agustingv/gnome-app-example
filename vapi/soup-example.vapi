[CCode (cheader_filename = "libsoup/soup.h", lower_case_cprefix = "soup_")]
namespace SoupExample
{
	[CCode (cname = "SoupSession", cprefix = "soup_session_", type_id = "soup_session_get_type ()")]
	public class Session : GLib.Object
	{
		[CCode (cname = "soup_session_new")]
		public Session ();

		[CCode (cname = "soup_session_send_and_read")]
		public GLib.Bytes send_and_read (Message msg, GLib.Cancellable? cancellable) throws GLib.Error;
	}

	[CCode (cname = "SoupMessage", cprefix = "soup_message_", type_id = "soup_message_get_type ()")]
	public class Message : GLib.Object
	{
		[CCode (cname = "soup_message_new")]
		public Message (string method, string uri_string);

		public uint status { get; }
	}
}
