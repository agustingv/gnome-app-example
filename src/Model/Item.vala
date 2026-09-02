namespace Example
{
  public class Item : Object
  {
        public string id         { get; construct; }
        public string title      { get; set; default = ""; }
        public string link	 { get; set; default = ""; }
        public string description { get; set; default = ""; }
        public string pubDate { get; set; default = ""; }

        public Item (string title, string link, string description, string pubDate)
        {
          Object (id: GLib.Uuid.string_random ());
          this.title = title;
          this.link = link;
          this.description = description;
          this.pubDate = pubDate;
        }
  }
  
}