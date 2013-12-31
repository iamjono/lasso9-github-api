[
/* =======================================================================
	Trees API
		Get a Tree
		Get a Tree Recursively
		Create a Tree
======================================================================= */
define github_trees => type {
	data
		public request::http_request    = http_request,
		public objectdata::array		= array

	/* =======================================================
	Get a Tree
		GET /repos/:owner/:repo/git/trees/:sha
	======================================================= */
	public get(-owner::string,-repo::string,-sha::string) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/git/trees/'+#sha
		return .request
	}
	/* =======================================================
	Get a Tree Recursively
		GET /repos/:owner/:repo/git/trees/:sha?recursive=1
	======================================================= */
	public get_recursive(-owner::string,-repo::string,-sha::string) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/git/trees/'+#sha+'?recursive=1'
//		.request->getParams = 'recursive=1'
		return .request
	}
	/* =======================================================
	Create a Tree

		The tree creation API will take nested entries as well. 
		If both a tree and a nested path modifying that tree are specified, 
		it will overwrite the contents of that tree with the new path contents and write a new tree out.
		POST /repos/:owner/:repo/git/trees
				
		Parameters
		Name		Type				Description
		tree		array of hashes		Required. Objects (of path, mode, type, and sha) 
										specifying a tree structure
		base_tree	string				The SHA1 of the tree you want to update with new data. 
										If you don’t set this, the commit will be created on top 
										of everything; however, it will only contain your change, 
										the rest of your files will show up as deleted.
		
		The tree parameter takes the following keys:
		path		string		The file referenced in the tree
		mode		string		The file mode; one of 100644 for file (blob), 100755 for executable (blob), 
								040000 for subdirectory (tree), 160000 for submodule (commit), 
								or 120000 for a blob that specifies the path of a symlink
		type		string		Either blob, tree, or commit
		sha			string		The SHA1 checksum ID of the object in the tree
		content		string		The content you want this file to have. 
								GitHub will write this blob out and use that SHA for this entry. 
								Use either this, or tree.sha.
		
		Input
		{
		  "base_tree": "9fb037999f264ba9a7fc6274d15fa3ae2ab98312",
		  "tree": [
		    {
		      "path": "file.rb",
		      "mode": "100644",
		      "type": "blob",
		      "sha": "44b4fc6d56897b048c772eb4087f854f46256132"
		    }
		  ]
		}

	======================================================= */
	public create(
		-owner::string,
		-repo::string,
		
		-base_tree::string,
		-tree::array
	) => {
		.request->urlPath = '/repos/'+#owner+'/'+#repo+'/git/trees'
		.request->method='POST'

		local(
			outmap = map(
				'base_tree'=#base_tree
			),
			trees = array
		)
		with t in #tree do => {
			#t->isA(::github_tree) ? 
				#trees->insert(#t->map) |
				#trees->insert(#t) // #t may have already been passed as a map. 
		}
		
		#trees->size ? #outmap->insert('tree' = #trees)
		
		.request->postParams = json_serialize(#outmap)
		
		return .request
	}

}
define github_tree => type {
	// github_tree is a pure data member. has none of the processing other gitub subtypes have.
	data
		public path::string 		= string,
		public mode::string 		= '100644',
		public typeof::string 		= 'blob',
		public sha::string			= string,
		public content::string		= string
	public validate() => {
		array('blob','tree','commit') !>> .typeof ? .typeof = 'blob'
		array('100644','100755', '040000', '160000', '120000') !>> .mode ? .mode = '100644'
		// now for specific restrictions
		.typeof == 'commit' ? .mode = '160000'
		.typeof == 'tree' ? .mode = '040000'
	}
	public map() => {
		return map(
			'path' 		= .path,
			'mode'		= .mode,
			'type'		= .typeof,
			'sha'		= .sha,
			'content'	= .content
		)
	}
	
}
]