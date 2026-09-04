using Gee;

namespace Example
{
	public class DummyRepository : Object, Repository
	{
		public ArrayList<Item> find()
		{
			var items = new ArrayList<Item>();
			items.add(new Item("Elemento uno del RSS", "https://example.com/uno", "<p>Descripción <b>larga</b> del elemento uno del RSS, pensada para comprobar que el texto ajusta (<i>wrap</i>) en varias líneas dentro de la fila en vez de cortarse con puntos suspensivos.</p>", "2026-04-01"));
			items.add(new Item("Elemento dos del RSS", "https://example.com/dos", "Descripción con <strong>HTML</strong> incrustado, un salto de línea<br/>y una entidad: A &amp; B.", "2026-08-02"));
			items.add(new Item("Elemento tres del RSS", "https://example.com/tres", "Descripción del elemento tres del RSS.", "2026-12-03"));
			return items;
		}
	}
}
