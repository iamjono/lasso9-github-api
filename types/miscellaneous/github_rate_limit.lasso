[
/* =======================================================================
	Skeleton
======================================================================= */
define github_rate_limit => type {
	trait { import github_common }	
	data
		protected prefix::string	= 'result_',
		protected u::string 		= string,
		protected p::string 		= 'x-oauth-basic',
		public user::string			= '',
		public objectdata::array	= array,
		public headers,
		public url::string			= string
}
]