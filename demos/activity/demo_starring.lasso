[
	// loads key. should be placed in the webroot, or however you wish!
	sys_listUnboundMethods !>> 'github_key' ? include('/github_key.lasso')
	
	// force reload of the type - comment out when not in dev
	include('../../types/activity/github_starring.lasso')
	

	
	
	/* =======================================================
	List Stargazers
	======================================================= */
	'List Stargazers for a specific repo:'+br
	local(obj)   = github('public')
	local(hub) = #obj->starring
	local(result) = #hub->stargazers(-owner='iamjono',-repo='lasso9-github-api')->response

	// output the whole array for debug
//	'<pre>'+#result->objectdata+'</pre>'
	
	loop(#result->size) => {^
		br
		loop_count+': stargazer: '+#result->login(loop_count)
	^}

	/* =======================================================
	List repositories being starred
	======================================================= */
	
	br+br+'List repositories being starred by a user:'
	local(obj)		= github('public')
	local(hub)		= #obj->starring
	local(result)	= #hub->starred(-user='bfad')->response

	loop(#result->size) => {^
		br
		loop_count+': full_name: '+#result->full_name(loop_count)
	^}

	br+br+'List repositories being watched by the authenticated user:'
	local(obj)   = github('basic')
	local(hub) = #obj->starring
	#hub->token(github_key)
	
	local(result) = #hub->starred->response
	loop(#result->size) => {^
		br
		loop_count+': full_name: '+#result->full_name(loop_count)
	^}

	/* =======================================================
	Check if you are starring a repository
	======================================================= */
	br+br+'Check if the authed user is starring a repository:'+br
	
	local(obj)   = github('basic')
	local(hub) = #obj->starring
	#hub->token(github_key)
	
	local(result) = #hub->check(-owner='bfad',-repo='lspec')
	'checking bfad/lspec: '+#result+br
	
	/* =======================================================
	Star a repository
	======================================================= */
	br+br+'Star a repository:'+br
	
	local(obj)   = github('basic')
	local(hub) = #obj->starring
	#hub->token(github_key)
	
	local(result) = #hub->star(-owner='wbond',-repo='package_control_channel')
	'starring wbond/package_control_channel: complete ('+#result->response->statusCode+')'+br
'<pre>'+#result->response->headers'</pre>'
	// checking:
	local(obj)   = github('basic')
	local(hub) = #obj->starring
	#hub->token(github_key)
	
	local(result) = #hub->check(-owner='wbond',-repo='package_control_channel')
	'checking wbond/package_control_channel: '+#result+br
	
	/* =======================================================
	UnStar a repository
	======================================================= */
	br+br+'UN-Star a repository:'+br
	
	local(obj)   = github('basic')
	local(hub) = #obj->starring
	#hub->token(github_key)
	
	local(result) = #hub->unstar(-owner='wbond',-repo='package_control_channel')
	
	'unstarring wbond/package_control_channel: complete ('+#result->response->statusCode+')'+br

	// checking:
	local(obj)   = github('basic')
	local(hub) = #obj->starring
	#hub->token(github_key)
	
	local(result) = #hub->check(-owner='wbond',-repo='package_control_channel')
	'checking wbond/package_control_channel: '+#result+br
	


]