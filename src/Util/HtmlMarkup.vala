using Gee;

namespace Example
{
	/**
	 * Converts (possibly HTML-flavoured) feed text into either plain text
	 * or a safe Pango markup subset, so it can be shown in a GtkLabel
	 * without leaking raw tags/entities or crashing the markup parser.
	 */
	public class HtmlMarkup
	{
		// Inline tags kept as real formatting; anything else is dropped (tag removed, text kept).
		private const string INLINE_TAGS = "b|strong|i|em|u|s|strike|del|tt|code";
		private static string[] NORMALIZED_INLINE_TAGS = { "b", "i", "u", "s", "tt" };

		// Placeholder markers used to shield content from escaping/stripping until
		// real markup is rebuilt afterwards. Private-Use-Area codepoints are legal
		// XML content, unlike C0 control chars, which Markup.escape_text numeric-
		// escapes (breaking a plain round trip through it). Built via unichar
		// rather than embedded as literal bytes, so nothing depends on the source
		// file preserving raw non-printable characters.
		private static string link_open ()  { return ((unichar) 0xE000).to_string (); }
		private static string link_close () { return ((unichar) 0xE001).to_string (); }
		private static string tag_open ()   { return ((unichar) 0xE002).to_string (); }
		private static string tag_close ()  { return ((unichar) 0xE003).to_string (); }

		private static string replace (string pattern, string subject, string replacement, bool caseless = true, bool dotall = false)
		{
			try {
				var flags = (caseless ? RegexCompileFlags.CASELESS : 0) | (dotall ? RegexCompileFlags.DOTALL : 0);
				var re = new Regex (pattern, flags);
				return re.replace (subject, -1, 0, replacement);
			} catch (RegexError e) {
				warning ("HtmlMarkup: regex '%s' failed: %s", pattern, e.message);
				return subject;
			}
		}

		private static string replace_eval (string pattern, string subject, owned RegexEvalCallback cb, bool caseless = true, bool dotall = false)
		{
			try {
				var flags = (caseless ? RegexCompileFlags.CASELESS : 0) | (dotall ? RegexCompileFlags.DOTALL : 0);
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

		/**
		 * Replace <a href="...">text</a> with a placeholder marker (so the
		 * href survives the later escape/strip passes) and collects the
		 * hrefs in order. Only http(s) links are kept as links; anything
		 * else keeps its visible text but loses the link. Must run before
		 * strip_unknown_tags().
		 */
		private static string extract_links (string input, Gee.ArrayList<string> hrefs)
		{
			return replace_eval (
				"<\\s*a\\s+[^>]*?href\\s*=\\s*([\"'])(.*?)\\1[^>]*>(.*?)<\\s*/\\s*a\\s*>",
				input,
				(match_info, result) => {
					var href = match_info.fetch (2);
					var inner = replace ("<[^>]+>", match_info.fetch (3), "");
					if (href.has_prefix ("http://") || href.has_prefix ("https://")) {
						result.append (link_open () + hrefs.size.to_string () + link_open () + inner + link_close ());
						hrefs.add (href);
					} else {
						result.append (inner);
					}
					return false;
				},
				true, true
			);
		}

		/** Turn allowed inline tags into placeholder markers that survive escaping/stripping. */
		private static string protect_inline_tags (string input)
		{
			var text = input;
			text = replace_eval ("<\\s*(" + INLINE_TAGS + ")\\s*>", text, (mi, res) => {
				res.append (tag_open () + normalize_tag (mi.fetch (1)) + tag_open ());
				return false;
			});
			text = replace_eval ("<\\s*/\\s*(" + INLINE_TAGS + ")\\s*>", text, (mi, res) => {
				res.append (tag_close () + normalize_tag (mi.fetch (1)) + tag_close ());
				return false;
			});
			return text;
		}

		/** Drop any tag that isn't a protected marker, keeping its text content. */
		private static string strip_unknown_tags (string input)
		{
			return replace ("<[^>]+>", input, "");
		}

		private static string resolve_inline_markers (string input)
		{
			var text = input;
			foreach (var tag in NORMALIZED_INLINE_TAGS) {
				text = text.replace (tag_open () + tag + tag_open (), "<" + tag + ">");
				text = text.replace (tag_close () + tag + tag_close (), "</" + tag + ">");
			}
			return text;
		}

		private static string resolve_link_markers (string input, Gee.ArrayList<string> hrefs)
		{
			var text = input;
			for (int i = 0; i < hrefs.size; i++) {
				text = text.replace (link_open () + i.to_string () + link_open (), "<a href=\"" + Markup.escape_text (hrefs[i]) + "\">");
			}
			text = text.replace (link_close (), "</a>");
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
		 * Decode entities, keep a safe subset of inline formatting tags
		 * (b, i, u, s and common aliases) plus http(s) links, and drop
		 * every other tag while keeping its text. Safe for
		 * Gtk.Label.set_markup().
		 */
		public static string to_pango_markup (string? html)
		{
			if (html == null || html == "") return "";

			var hrefs = new Gee.ArrayList<string> ();

			var text = decode_entities (html);
			text = extract_links (text, hrefs);
			text = protect_inline_tags (text);
			text = convert_block_structure (text);
			text = strip_unknown_tags (text);

			text = Markup.escape_text (text);

			text = resolve_inline_markers (text);
			text = resolve_link_markers (text, hrefs);

			return collapse_blank_lines (text);
		}
	}
}
