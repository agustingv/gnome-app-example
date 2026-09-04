namespace Example
{
	/**
	 * Converts (possibly HTML-flavoured) feed text into either plain text
	 * or a safe Pango markup subset, so it can be shown in a GtkLabel
	 * without leaking raw tags/entities or crashing the markup parser.
	 */
	public class HtmlMarkup
	{
		private static string replace (string pattern, string subject, string replacement, bool caseless = true)
		{
			try {
				var flags = caseless ? RegexCompileFlags.CASELESS : 0;
				var re = new Regex (pattern, flags);
				return re.replace (subject, -1, 0, replacement);
			} catch (RegexError e) {
				warning ("HtmlMarkup: regex '%s' failed: %s", pattern, e.message);
				return subject;
			}
		}

		private static string replace_eval (string pattern, string subject, owned RegexEvalCallback cb, bool caseless = true)
		{
			try {
				var flags = caseless ? RegexCompileFlags.CASELESS : 0;
				var re = new Regex (pattern, flags);
				return re.replace_eval (subject, -1, 0, 0, (owned) cb);
			} catch (RegexError e) {
				warning ("HtmlMarkup: regex '%s' failed: %s", pattern, e.message);
				return subject;
			}
		}

		private static string normalize_tag (string raw)
		{
			var tag = raw.down ();
			if (tag == "strong") return "b";
			if (tag == "em") return "i";
			if (tag == "strike" || tag == "del") return "s";
			if (tag == "code") return "tt";
			return tag;
		}

		private static string decode_entities (string input)
		{
			var text = input;
			text = text.replace ("&nbsp;", " ");
			text = text.replace ("&lt;", "<");
			text = text.replace ("&gt;", ">");
			text = text.replace ("&quot;", "\"");
			text = text.replace ("&#39;", "'");
			text = text.replace ("&apos;", "'");
			text = text.replace ("&amp;", "&"); // must be last
			return text;
		}

		private static string collapse_blank_lines (string input)
		{
			return replace ("\\n{3,}", input, "\n\n", false).strip ();
		}

		private static string convert_block_structure (string input)
		{
			var text = input;
			text = replace ("<\\s*br\\s*/?\\s*>", text, "\n");
			text = replace ("</\\s*p\\s*>", text, "\n\n");
			text = replace ("<\\s*p[^>]*>", text, "");
			text = replace ("</\\s*li\\s*>", text, "\n");
			text = replace ("<\\s*li[^>]*>", text, "• ");
			text = replace ("</?\\s*(ul|ol|div|table|tr|td)[^>]*>", text, "\n");
			return text;
		}

		/** Decode entities and strip every tag. Safe for Gtk.Label.set_text(). */
		public static string to_plain_text (string? html)
		{
			if (html == null || html == "") return "";
			var text = decode_entities (html);
			text = convert_block_structure (text);
			text = replace ("<[^>]+>", text, "", false);
			return collapse_blank_lines (text);
		}

		/**
		 * Decode entities and keep a safe subset of inline tags
		 * (b, i, u, s and their common aliases); everything else is
		 * escaped or dropped. Safe for Gtk.Label.set_markup().
		 */
		public static string to_pango_markup (string? html)
		{
			if (html == null || html == "") return "";

			var text = decode_entities (html);
			text = convert_block_structure (text);
			text = Markup.escape_text (text);

			text = replace_eval ("&lt;\\s*(b|strong|i|em|u|s|strike|del|tt|code)\\s*&gt;", text, (match_info, result) => {
				result.append ("<" + normalize_tag (match_info.fetch (1)) + ">");
				return false;
			});

			text = replace_eval ("&lt;\\s*/\\s*(b|strong|i|em|u|s|strike|del|tt|code)\\s*&gt;", text, (match_info, result) => {
				result.append ("</" + normalize_tag (match_info.fetch (1)) + ">");
				return false;
			});

			return collapse_blank_lines (text);
		}
	}
}
