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
'<pre>'+#result+'</pre>'
//	'starring lspec: '+#result->+br
	
	/* =======================================================
	Set a Repository Subscription
	props at http://developer.github.com/v3/activity/watching/#set-a-repository-subscription
	array(
		map(
			avatar_url = https://1.gravatar.com/avatar/cf6529acf8fd49f9e08fc756f5b9c90e?d=https%3A%2F%2Fidenticons.github.com%2Fa80cc21aa462cac9e6f20e69bef733f8.png&r=x, 
			bio = , 
			blog = http://jono.guthrie.net.nz, 
			collaborators = 0, 
			company = LassoSoft Inc, 
			created_at = 2013-03-06T16:27:42Z, 
			disk_usage = 1742, 
			email = jono@lassosoft.com, 
			events_url = https://api.github.com/users/iamjono/events{/privacy}, 
			followers = 6, 
			followers_url = https://api.github.com/users/iamjono/followers, 
			following = 5, following_url = https://api.github.com/users/iamjono/following{/other_user}, 
			gists_url = https://api.github.com/users/iamjono/gists{/gist_id}, 
			gravatar_id = cf6529acf8fd49f9e08fc756f5b9c90e, 
			hireable = false, html_url = https://github.com/iamjono, 
			id = 3789179, location = Newmarket, Canada, login = iamjono, name = Jonathan Guthrie, organizations_url = https://api.github.com/users/iamjono/orgs, owned_private_repos = 0, plan = map(collaborators = 0, name = free, private_repos = 0, space = 307200), private_gists = 0, public_gists = 4, public_repos = 12, received_events_url = https://api.github.com/users/iamjono/received_events, repos_url = https://api.github.com/users/iamjono/repos, site_admin = false, starred_url = https://api.github.com/users/iamjono/starred{/owner}{/repo}, subscriptions_url = https://api.github.com/users/iamjono/subscriptions, total_private_repos = 0, type = User, updated_at = 2013-11-15T22:00:24Z, url = https://api.github.com/users/iamjono))

		======================================================= */
//	br+br+'Set a Repository Subscription for a user & repo:'+br
//	local(obj)   = github('basic')
//	local(hub) = #obj->starring
//	#hub->token(github_key)
//	
//	local(result) = #hub->set_subscription(-owner='bfad',-repo='lspec',-subscribed=true,-ignored=false)->response
//
//	'<pre>URL: '+#result->url+'</pre>'
//	'subscribed: '+#result->subscribed+br
//	'ignored: '+#result->ignored+br
//	'reason: '+#result->reason+br

	/* =======================================================
	DELETE a Repository Subscription
	======================================================= */
//	br+br+'Delete a Repository Subscription for a user & repo:'+br
//	local(obj)   = github('basic')
//	local(hub) = #obj->starring
//	#hub->token(github_key)
//	
//	local(result) = #hub->delete_subscription(-owner='bfad',-repo='lspec')->response
//	#result->response->statusCode

]