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
	data
		public request::http_request    = http_request,
		public objectdata::array		= array


	
}
]