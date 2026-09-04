using Gee;

namespace Example
{
	public interface Repository : GLib.Object
	{
		public abstract ArrayList<Item> find();
	}
}
