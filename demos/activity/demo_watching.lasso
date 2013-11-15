[
	sys_listunboundmethods !>> 'br' ? define br => '<br>'
	define br => '<br>'
	sys_listtraits !>> 'github_common' ? include('../../types/github_common.lasso')
	
	sys_listtypes !>> 'github_parent' ? include('../../types/github_parent.lasso')
		
	sys_listtypes !>> 'github_header' ? include('../../types/github_header.lasso')
		
	// force reload of the type - comment out when not in dev
	include('../../types/activity/github_watching.lasso')
	

	
	
	/* =======================================================
	Who's watching a specific repo
	properties that shoud be available:
	- login
	- id
	- avatar_url
	- gravatar_id
	- url
	======================================================= */
	'List who is watching a specific repo:'+br
	local(obj = github_watching)
	#obj->list_watchers(-owner='iamjono',-repo='lasso9-github-api')
	// output the whole array for debug
//	'<pre>'+#obj->objectdata+'</pre>'
	
	loop(#obj->size) => {^
		br
		loop_count+': watcher: '+#obj->watching_login(loop_count)
	^}

	/* =======================================================
	List repositories being watched
		List repositories being watched by a user.
		List repositories being watched by the authenticated user.
	props at http://developer.github.com/v3/activity/watching/#list-repositories-being-watched
	======================================================= */
	
	br+br+'List repositories being watched by a user:'
	local(obj = github_watching)
	#obj->list_watching(-user='bfad')
	loop(#obj->size) => {^
		br
		loop_count+': full_name: '+#obj->watching_full_name(loop_count)
	^}

	br+br+'List repositories being watched by the authenticated user:'
	local(obj = github_watching)
	#obj->token(github_key)
	#obj->list_watching
	loop(#obj->size) => {^
		br
		loop_count+': full_name: '+#obj->watching_full_name(loop_count)
	^}

	/* =======================================================
	Get a Repository Subscription
	props at http://developer.github.com/v3/activity/watching/#get-a-repository-subscription
	
	!!!!UPDATE: Even their example does not work.!!!!
	======================================================= */
	br+br+'Get a Repository Subscription for a user & repo:'
	local(obj = github_watching)
	#obj->token(github_key) // authenticated just make sure within rate limiting
	#obj->get_subscription(-owner='bfad',-repo='lspec')
	'<pre>'+#obj->objectdata+'</pre>'
	'subscribed: '+#obj->watching_subscribed+br
	'ignored: '+#obj->watching_ignored+br
	'reason: '+#obj->watching_reason+br
	
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
	br+br+'Set a Repository Subscription for a user & repo:'
	local(obj = github_watching)
	#obj->token(github_key) // authenticated just make sure within rate limiting
	#obj->set_subscription(-owner='bfad',-repo='lspec',-subscribed=false,-ignored=false)
	'<pre>URL: '+#obj->url+'</pre>'
	'<pre>objectdata: '+#obj->objectdata+'</pre>'
	'subscribed: '+#obj->watching_subscribed+br
	'ignored: '+#obj->watching_ignored+br
	'reason: '+#obj->watching_reason+br
	
]