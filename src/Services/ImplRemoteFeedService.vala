using Gee;

namespace Example
{
	public class ImplRemoteFeedService : Object, Service
	{
		public Repository repo { get; construct; }

		public ImplRemoteFeedService (Repository repo)
		{
			Object(repo: repo);
		}

		public Item[] find()
		{
			return repo.find().to_array();
		}
	}
}
