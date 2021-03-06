[
/* =======================================================================
	List all public repositories (GET /repositories) not supported (yet)
======================================================================= */
define github_repos => type {
	data
		protected prefix::string		= 'repos_',
		public request::http_request    = http_request,
		public objectdata::array			= array

	// standard get method
	public get(
		-user::string		= '',
		-org::string		= '',
		-type::string		= '',
		-sort::string		= '',
		-direction::string	= ''
		) => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array, params = array)
			if(#user->size) => {
				//repos for the specified user
				#urlstring->insert('users')
				#urlstring->insert(#user)
				array('all', 'owner', 'public', 'private', 'member') >> #type ? #params->insert('type='+#type) 
				array('created', 'updated', 'pushed', 'full_name') >> #sort ? #params->insert('sort='+#sort) 
				#direction == 'desc' ? #params->insert('direction=desc') | #params->insert('direction=asc') 
			else(#org->size)
				// repos for the org
				#urlstring->insert('orgs')
				#urlstring->insert(#org)
				#type->size && array('all', 'owner', 'member') >> #type ? #params->insert('type='+#type) 
				#sort->size && array('created', 'updated', 'pushed', 'full_name') >> #sort ? #params->insert('sort='+#sort) 
				#direction == 'desc' ? #params->insert('direction=desc') | #params->insert('direction=asc') 
			else
				// repos for the authenticated user
				#urlstring->insert('user')
				#type->size && array('all', 'public', 'private', 'forks', 'sources', 'member') >> #type ? #params->insert('type='+#type) 
			}
			
			// make and return request
			.request->urlPath = '/'+#urlstring->join('/')+'/repos'+(#params->size ? '?'+#params->join('&'))
			return .request
		}
	}
	
	/* ===================================================
	CREATE REPOS 
	Input
		name 				- Required string
		description			- Optional string
		homepage			- Optional string
		private				- Optional boolean 
								true to create a private repository, 
								false to create a public one. 
								Creating private repositories requires a paid GitHub account. Default is false.
		has_issues			- Optional boolean
								true to enable issues for this repository, 
								false to disable them. Default is true.
		has_wiki			- Optional boolean
								true to enable the wiki for this repository, 
								false to disable it. Default is true.
		has_downloads		- Optional boolean
								true to enable downloads for this repository, 
								false to disable them. Default is true.
		team_id				- Optional number
								The id of the team that will be granted access to this repository. 
								This is only valid when creating a repo in an organization.
		auto_init			- Optional boolean
								true to create an initial commit with empty README. Default is false.
		gitignore_template 	- Optional string
								Desired language or platform .gitignore template to apply. 
								Use the name of the template without the extension. 
								For example, “Haskell” Ignored if auto_init parameter is not provided.
	=================================================== */
	public create(
		-name::string,
		-org::string			= '',
		-description::string	= '',
		-homepage::string		= '',
		-private::boolean		= false,
		-has_issues::boolean	= true,
		-has_wiki::boolean		= true,
		-has_downloads::boolean	= true,
		-team_id::integer		= 0,
		-auto_init::boolean		= false,
		-gitignore_template::string	= ''
		) => {
		/* ===========================================================
		Save optional params to a map to be serialized in the post data
		=========================================================== */
		local(outmap = map)
		#outmap->insert('name' = #name) // required
		// all other params are optional
		#description->size ? #outmap->insert('description' = #description)
		#outmap->insert('private' = #private)
		#outmap->insert('has_issues' = #has_issues)
		#outmap->insert('has_wiki' = #has_wiki)
		#outmap->insert('has_downloads' = #has_downloads)
		#team_id > 0 ? #outmap->insert('team_id' = #team_id)
		#outmap->insert('auto_init' = #auto_init)
		#gitignore_template->size ? #outmap->insert('gitignore_template' = #gitignore_template)
		
		/* ===========================================================
		Push the PATCH via JSON and get the new data
		can't use .run because of custom...
		=========================================================== */
		// make and return request
		#org->size ?
			.request->urlPath = '/orgs/'+#org+'/repos' | 
			.request->urlPath = '/user/repos'
		.request->postParams = json_serialize(#outmap)
		return .request
	} // end create
	
	/* ===============================
	GET REPOS
		requires owner and repo
	=============================== */
	public getrepo(
		-owner::string,
		-repo::string
		) => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array, params = array)
			#urlstring->insert('repos')
			#urlstring->insert(#owner)
			#urlstring->insert(#repo)
			
			// make and return request
			.request->urlPath = '/'+#urlstring->join('/')
			return .request
		}
	}

	
	/* ===============================
	EDIT REPOS
		requires owner and repo, and name
	Same params as create, less team_id and auto_init
	Additional:
		default_branch
			Optional String - Update the default branch for this repository.
	=============================== */
	public edit(
		-owner::string,
		-repo::string,
		-name::string,
		
		-description::string	= '',
		-homepage::string		= '',
		-private::boolean		= false,
		-has_issues::boolean	= true,
		-has_wiki::boolean		= true,
		-has_downloads::boolean	= true,
		-default_branch::string	= ''

		) => {
		
		local(urlstring = array)
		#urlstring->insert('repos')
		#urlstring->insert(#owner)	// required
		#urlstring->insert(#repo)	// required
		
		/* ===========================================================
		Save optional params to a map to be serialized in the post data
		=========================================================== */
		local(outmap = map)
		#outmap->insert('name' = #name) // required
		// all other params are optional
		#description->size ? #outmap->insert('description' = #description)
		#outmap->insert('private' = #private)
		#outmap->insert('has_issues' = #has_issues)
		#outmap->insert('has_wiki' = #has_wiki)
		#outmap->insert('has_downloads' = #has_downloads)
		#default_branch->size ? #outmap->insert('default_branch' = #default_branch)
		
		/* ===========================================================
		Push the PATCH via JSON and get the new data
		can't use .run because of custom...
		=========================================================== */
		
		// make and return request
		.request->urlPath = '/'+#urlstring->join('/')
		.request->postParams = json_serialize(#outmap)
		return .request
	}

	private lists(urlstring::array, params::array) => {
		// make and return request
		.request->urlPath = '/'+#urlstring+(#params->size ? '?'+#params->join('&'))
		return .request
	}
	
	/* ===============================
	List contributors
		GET /repos/:owner/:repo/contributors
		anon
			Optional flag. Set to 1 or true to include anonymous contributors in results.
	=============================== */
	public list_contributors(
		-owner::string,
		-repo::string,
		-anon::boolean		= false
		) => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array('repos',#owner,#repo,'contributors'))			
			local(params = array('anon='+#anon))
			.lists(#urlstring,#params)
		}
	}
	/* ===============================
	List languages
		List languages for the specified repository. 
		The value on the right of a language is the number of bytes of code written in that language.
		GET /repos/:owner/:repo/languages
	=============================== */
	public list_languages(
		-owner::string,
		-repo::string
		) => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array('repos',#owner,#repo,'languages'))						
			.lists(#urlstring,array)
		}
	}
	/* ===============================
	List teams
		GET /repos/:owner/:repo/teams
	=============================== */
	public list_teams(
		-owner::string,
		-repo::string
		) => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array('repos',#owner,#repo,'teams'))
			.lists(#urlstring,array)
		}
	}
	/* ===============================
	List tags
		GET /repos/:owner/:repo/tags
	=============================== */
	public list_tags(
		-owner::string,
		-repo::string
		) => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array('repos',#owner,#repo,'tags'))			
			.lists(#urlstring,array)

		}
	}
	/* ===============================
	List branches
		GET /repos/:owner/:repo/branches
	=============================== */
	public list_branches(
		-owner::string,
		-repo::string
		) => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			.request->urlPath = '/repos/'+#owner+'/'+#repo+'/branches'
//			log_critical(.request->urlPath)
			return .request
		}
	}
	/* ===============================
	Get Branch
		GET /repos/:owner/:repo/branches/:branch
	=============================== */
	public get_branch(
		-owner::string,
		-repo::string,
		-branch::string
		) => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array('repos',#owner,#repo,'branches',#branch))			
			.lists(#urlstring,array)
		}
	}
	/* ===============================
	Delete a Repository
		Deleting a repository requires admin access. 
		If OAuth is used, the delete_repo scope is required.
		DELETE /repos/:owner/:repo
	=============================== */
	public delete(
		-owner::string,
		-repo::string
		) => {
		protect => {
			handle_error => { return error_msg+'<pre>'+error_stack+'</pre>' }
			local(urlstring = array('repos',#owner,#repo))		
				
			// make and return request
			.request->method='DELETE'
			.request->urlPath = '/'+#urlstring->join('/')
			return .request
			
			
		}
	}
}
]