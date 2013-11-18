[
/* =======================================================================
	List Feeds
	
	GitHub provides several timeline resources in Atom format. 
	The Feeds API lists all the feeds available to the authenticating user
======================================================================= */
define github_feeds => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array

	
}
]