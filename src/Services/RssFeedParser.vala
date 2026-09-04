using Gee;

namespace Example
{
	public class RssFeedParser : GLib.Object
	{
		public ArrayList<Item> parse (string xml) throws GLib.Error
		{
			var items = new ArrayList<Item> ();

			Xml.Doc* doc = Xml.Parser.parse_memory (xml, xml.length);

			if (doc == null) {
				Xml.Error* error = Xml.get_last_error ();
				throw new GLib.IOError.FAILED (error != null ? error->message.strip () : "Malformed XML");
			}

			Xml.Node* root = doc->get_root_element ();

			if (root != null) {
				for (Xml.Node* channel = root->children; channel != null; channel = channel->next) {
					if (channel->name != "channel") continue;

					for (Xml.Node* node = channel->children; node != null; node = node->next) {
						if (node->name != "item") continue;
						items.add (parse_item (node));
					}
				}
			}

			delete doc;
			return items;
		}

		private Item parse_item (Xml.Node* node)
		{
			string title = "", link = "", description = "", pubDate = "";

			for (Xml.Node* field = node->children; field != null; field = field->next) {
				string content = field->get_content () ?? "";

				switch (field->name) {
					case "title": title = content; break;
					case "link": link = content; break;
					case "description": description = content; break;
					case "pubDate": pubDate = content; break;
				}
			}

			return new Item (title, link, description, pubDate);
		}
	}
}
