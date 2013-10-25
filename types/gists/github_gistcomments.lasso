[
/* =======================================================================
	Gist Comments API
	
	Gist Comments use these custom media types. 
		http://developer.github.com/v3/gists/comments/#custom-media-types 
	You can read more about the use of media types in the API here. 
		http://developer.github.com/v3/media/
		
		List comments on a gist
		Get a single comment
		Create a comment
		Edit a comment
		Delete a comment
		Custom media types
======================================================================= */
define github_gistcomments => type {
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