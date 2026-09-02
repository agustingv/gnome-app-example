using Gee;

namespace Example
{
	public class ItemListViewModel : Object
	{
		public ArrayList<Item> items { get; private set; default = new ArrayList<Item> (); }

		private Service service = new ImplRemoteFeedService (new DummyRepository ());

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
