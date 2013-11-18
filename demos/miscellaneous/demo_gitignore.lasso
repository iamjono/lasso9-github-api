[
//	sys_listtypes !>> 'github_gitignore' ? 
		include('../../types/miscellaneous/github_gitignore.lasso')
	

	local(obj)   = github('public')
	local(gitignore) = #obj->gitignore
	local(result) = #gitignore->list->response
	
	
	/* =======================================================
	List gitignore templates
	======================================================= */
	'List gitignore templates'+br
	'<blockquote>'
	loop(#result->objectdata->size) => {^
		#result->objectdata->get(loop_count) + br
	^}
	'</blockquote>'
	
	/* =======================================================
	Get a gitignore template
	======================================================= */
	'Get a gitignore template (C)'+br
	local(obj)   = github('public')
	local(gitignore) = #obj->gitignore
	local(result) = #gitignore->get('C')->response
	'Name: '+#result->name+br
	'Source: '+br+#result->source+br
]