[
	// loades key. should be placed in the webroot, or however you wish!
	sys_listUnboundMethods !>> 'github_key' ? include('/github_key.lasso')
	
	// uncomment to force reload
	include('../types/main/github_repos.lasso')
	
	

	
	local(obj)   = github('public')
	local(repos) = #obj->repos
	
	/* =======================================================
	Get info about a specified user
	======================================================= */
	'Get info about a specified users repos'+br
//	#repos->get(-user='fletc3her')
//	local(result) = #repos->get(-user='fletc3her')->response
	local(result) = #repos->get(-user='zeroloop',-sort='created')->response
	// use for troubleshooting
	#result->url
//	br
	// output the whole array for debug
//	'<pre>'+#result->objectdata+'</pre>'
	
	br+'full_name: '+#result->full_name
	loop(#result->size) => {^
		br+loop_count+': full_name: '+#result->full_name(loop_count)
	^}

	/* =======================================================
	Get the authenticated user
	======================================================= */
	local(obj)   = github('basic')
	local(repos) = #obj->repos
	#repos->token(github_key)

	br+br+'Get the authenticated users repos'
	local(result) = #repos->get(-thisuser)->response
	br+'# repos: '+#result->size
	br+'default, first full_name: '+#result->full_name
	br
	
	loop(#result->size) => {^
		br+loop_count+': full_name: '+#result->full_name(loop_count)
	^}

	/* =======================================================
	Get repos for an org
	======================================================= */
	local(obj)   = github('basic')
	local(repos) = #obj->repos
	#repos->token(github_key)
	local(result) = #repos->get(-org='LassoSoft')->response
	
	br+br+'Get repos for an org'
	br+'Org:'+#result->owner->find('login')+br
	
	br+'url: '+#result->url
	br+br+br+'# repos: '+#result->size
	br+'default, first full_name: '+#result->full_name
	br
	
	loop(#result->size) => {^
		br+loop_count+': full_name: '+#result->full_name(loop_count)
	^}

]