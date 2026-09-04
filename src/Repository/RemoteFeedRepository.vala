using Gee;

namespace Example
{
	public class RemoteFeedRepository : Object, Repository
	{
		public string url { get; construct; }

		private HttpClient http_client;
		private XmlValidator xml_validator;
		private RssFeedParser feed_parser;

		public RemoteFeedRepository (string url)
		{
			Object (url: url);
		}

		construct
		{
			http_client = new HttpClient ();
			xml_validator = new XmlValidator ();
			feed_parser = new RssFeedParser ();
		}

		public ArrayList<Item> find ()
		{
			try {
				string xml = http_client.fetch (url);

				string? error_message;
				if (!xml_validator.is_valid (xml, out error_message)) {
					warning ("Invalid RSS feed XML from %s: %s", url, error_message);
					return new ArrayList<Item> ();
				}

				return feed_parser.parse (xml);
			} catch (Error e) {
				warning ("Failed to load RSS feed from %s: %s", url, e.message);
				return new ArrayList<Item> ();
			}
		}
	}
}
