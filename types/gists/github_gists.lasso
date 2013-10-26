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
	parent github_parent
	data
		public objectdata::array		= array


	
}
]