using Gee;

namespace Example
{
	public class ItemListViewModel : Object
	{
		public ArrayList<Item> items { get; private set; default = new ArrayList<Item> (); }

		private Service service = new ImplRemoteFeedService (new RemoteFeedRepository("https://news.google.com/rss?hl=es&gl=ES&ceid=ES:es"));

		construct
		{
			load ();
		}

		public void load ()
		{
			items.clear ();
			foreach (var item in service.find ())
			{
				items.add (item);
			}
		}
	}
}
