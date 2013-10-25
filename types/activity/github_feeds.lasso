[
/* =======================================================================
	List Feeds
	
	GitHub provides several timeline resources in Atom format. 
	The Feeds API lists all the feeds available to the authenticating user
======================================================================= */
define github_feeds => type {
	trait { import github_common }	
	data
		protected prefix::string	= 'result_',
		protected u::string 		= string,
		protected p::string 		= 'x-oauth-basic',
		public user::string			= '',
		public objectdata::array	= array,
		public headers				= github_header,
		public url::string			= string


	
}
]