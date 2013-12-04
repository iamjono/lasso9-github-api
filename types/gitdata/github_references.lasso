[
/* =======================================================================
	Skeleton
======================================================================= */
define github_references => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array
	/* =======================================================
	Get a Reference
		GET /repos/:owner/:repo/git/refs/:ref
	
		The ref in the URL must be formatted as heads/branch, not just branch. 
		For example, the call to get the data for a branch named skunkworkz/featureA would be:
		GET /repos/:owner/:repo/git/refs/heads/skunkworkz/featureA
	======================================================= */
	public get(-owner::string,-repo::string,-ref::string) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/git/refs/'+#ref
		return .request
	}

	/* =======================================================
	Get all References
		GET /repos/:owner/:repo/git/refs

		This will return an array of all the references on the system, 
		including things like notes and stashes if they exist on the server. 
		Anything in the namespace, not just heads and tags, though that would be the most common.
		
		You can also request a sub-namespace. 
		For example, to get all the tag references, you can call:
		GET /repos/:owner/:repo/git/refs/tags
	======================================================= */
	public getall(-owner::string,-repo::string,-sub::string) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/git/refs/'+#sub
		return .request
	}
	/* =======================================================
	Create a Reference
		POST /repos/:owner/:repo/git/refs
		
		Parameters
		Name	Type	Description
		ref		type	The name of the fully qualified reference (ie: refs/heads/master). 
						If it doesn’t start with ‘refs’ and have at least two slashes, it will be rejected.
		sha		type	The SHA1 value to set this reference to
		
		Input
		{
		  "ref": "refs/heads/master",
		  "sha": "827efc6d56897b048c772eb4087f854f46256132"
		}
	======================================================= */
	public create(
		-owner::string,
		-repo::string,
		-ref::string,
		-sha::string
	) => {
		local(outmap = map('ref' = #ref,'sha' = #sha))
		.request->postParams = json_serialize(#outmap)
		.request->method='POST'
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/git/refs'
		return .request
	}
	/* =======================================================
	Update a Reference
		PATCH /repos/:owner/:repo/git/refs/:ref

		Parameters		
		Name	Type	Description
		sha		type	The SHA1 value to set this reference to
		force	boolean	Indicates whether to force the update or to make 
						sure the update is a fast-forward update. 
						Leaving this out or setting it to false will
						 make sure you’re not overwriting work. 
						 Default: false
		
		Input
		{
		  "sha": "aa218f56b14c9653891f9e74264a383fa43fefbd",
		  "force": true
		}
	======================================================= */
	public update(
		-owner::string,
		-repo::string,
		-ref::string,
		-sha::string,
		-force=void
	) => {
		local(outmap = map('sha' = #sha))
		#force->isA(::boolean)
			? #outmap->insert('force' = #force) 
		.request->postParams = json_serialize(#outmap)
		.request->method='PATCH'
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/git/refs/'+#ref
		return .request
	}
	/* =======================================================
	Delete a Reference
		DELETE /repos/:owner/:repo/git/refs/:ref

		Example: Deleting a branch:
		DELETE /repos/octocat/Hello-World/git/refs/heads/feature-a
		
		Example: Deleting a tag:
		DELETE /repos/octocat/Hello-World/git/refs/tags/v1.0		
	======================================================= */
	public delete(
		-owner::string,
		-repo::string,
		-ref::string
		) => {
		.request->method='DELETE'
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/git/refs/'+#ref
		return .request
	}
}
]