using Gee;

namespace Example
{
	public class DummyRepository : Object, Repository
	{
		public ArrayList<Item> find()
		{
			var items = new ArrayList<Item>();
			items.add(new Item("Elemento uno del RSS", "https://example.com/uno", "Descripción del elemento uno del RSS.", "2026-04-01"));
			items.add(new Item("Elemento dos del RSS", "https://example.com/dos", "Descripción del elemento dos del RSS.", "2026-08-02"));
			items.add(new Item("Elemento tres del RSS", "https://example.com/tres", "Descripción del elemento tres del RSS.", "2026-12-03"));
			return items;
		}
	}
}
