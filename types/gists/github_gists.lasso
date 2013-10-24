[
/* =======================================================================
	Gists API
	
		Authentication
			You can read public gists and create them for anonymous users 
			without a token; however, to read or write gists on a user’s 
			behalf the gist OAuth scope is required.
		List gists
		Get a single gist
		Create a gist
		Edit a gist
		Star a gist
		Unstar a gist
		Check if a gist is starred
		Fork a gist
		Delete a gist
======================================================================= */
define github_gists => type {
	trait { import github_common }	
	data
		protected prefix::string	= 'gists_',
		protected u::string 		= string,
		protected p::string 		= 'x-oauth-basic',
		public user::string			= '',
		public objectdata::array	= array,
		public headers,
		public url::string			= string


	
}
]