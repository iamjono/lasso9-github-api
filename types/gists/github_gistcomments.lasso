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

	/* =======================================================
	List comments on a gist
		GET /gists/:gist_id/comments
	======================================================= */
	public list(-gistid::integer) => {
		.request->urlPath = '/gists/'+#gistid+'/comments'
		return .request
	}
	/* =======================================================
	Get a single comment
		GET /gists/:gist_id/comments/:id
	======================================================= */
	public get(-gistid::integer,-id::integer) => {
		.request->urlPath = '/gists/'+#gistid+'/comments/'+#id
		return .request
	}
	/* =======================================================
	Create a comment
		POST /gists/:gist_id/comments
		
		Parameters
		Name	Type	Description
		body	string	Required. The comment text.
	======================================================= */
	public create(-gistid::integer,-body::string) => {
		.request->urlPath = '/gists/'+#gistid+'/comments'
		.request->method='POST'

		local(outmap = map('body' = #body))
		.request->postParams = json_serialize(#outmap)
		return .request
	}
	/* =======================================================
	Edit a comment
		PATCH /gists/:gist_id/comments/:id

		Input		
		Name	Type	Description
		body	string	Required. The comment text.
	======================================================= */
	public edit(-gistid::integer,-id::integer,-body::string) => {
		.request->urlPath = '/gists/'+#gistid+'/comments/'+#id
		.request->method='PATCH'

		local(outmap = map('body' = #body))
		.request->postParams = json_serialize(#outmap)
		return .request
	}
	/* =======================================================
	Delete a comment
		DELETE /gists/:gist_id/comments/:id
	======================================================= */
	public delete(-gistid::integer,-id::integer) => {
		.request->urlPath = '/gists/'+#gistid+'/comments/'+#id
		.request->method='DELETE'
		return .request
	}

	
}
]