using Gee;

namespace Example
{
	public class ImplRepositoryOne : Object, Repository
	{
		public ArrayList<Item> find()
		{
			return new ArrayList<Item> ();
		}
	}
}
