[
/* =======================================================================
	List Feeds
	
	GitHub provides several timeline resources in Atom format. 
	The Feeds API lists all the feeds available to the authenticating user
======================================================================= */
define github_feeds => type {
	parent github_parent
	data
		public objectdata::array		= array

	
}
]