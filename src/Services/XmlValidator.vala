namespace Example
{
	public class XmlValidator : GLib.Object
	{
		public bool is_valid (string xml, out string? error_message)
		{
			error_message = null;

			Xml.Doc* doc = Xml.Parser.parse_memory (xml, xml.length);

			if (doc == null) {
				Xml.Error* error = Xml.get_last_error ();
				error_message = (error != null) ? error->message.strip () : "Malformed XML";
				return false;
			}

			delete doc;
			return true;
		}
	}
}
