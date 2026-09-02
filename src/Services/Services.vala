namespace Example 
{
	public interface Service : GLib.Object
	{
		public abstract Item[] find();
	}
}