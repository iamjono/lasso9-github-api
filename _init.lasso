[
	sys_listunboundmethods !>> 'br' ? define br => '<br>'
	
	// http_request and http_response objects
	sys_listtypes !>> 'http_request' ? include('Lasso-HTTP/http_request.lasso')
	sys_listtypes !>> 'http_response' ? include('Lasso-HTTP/http_response.lasso')
	
	// common trait element
	sys_listtraits !>> 'github_common' ? include('types/github_common.lasso')
	
	// header type
	sys_listtypes !>> 'github_header' ? include('types/github_header.lasso')

	// parent object
	sys_listtraits !>> 'github_parent' ? include('types/github_parent.lasso')
	
	// user object
	sys_listtypes !>> 'github_user' ? include('types/github_user.lasso')
	
	// repos object
	sys_listtypes !>> 'github_repos' ? include('types/github_repos.lasso')
	
	local(
		activity = array(
			'github_events',
			'github_eventtypes',
			'github_feeds',
			'github_notifications',
			'github_starring',
			'github_watching'
		),
		gists = array(
			'github_gists',
			'github_gistcomments'
		),
		gitdata = array(
			'github_blobs',
			'github_commits',
			'github_references',
			'github_tags',
			'github_trees'
		),
		issues = array(
			'github_issues_assignees',
			'github_issues_comments',
			'github_issues_events',
			'github_issues_labels',
			'github_issues_milestones',
			'github_issues'
		),
		miscellaneous = array(
			'github_emojis',
			'github_gitignore',
			'github_markdown',
			'github_meta',
			'github_rate_limit'
		),
		orgs = array(
			'github_members',
			'github_orgs',
			'github_teams'
		),
		pulls = array(
			'github_pulls_comments',
			'github_pulls'
		)
	)
//	with f in #activity do => { 		sys_listtypes !>> #f ? include('types/activity/'+#f+'.lasso') 		}
//	with f in #gists do => { 			sys_listtypes !>> #f ? include('types/gists/'+#f+'.lasso') 			}
//	with f in #gitdata do => { 			sys_listtypes !>> #f ? include('types/gitdata/'+#f+'.lasso') 			}
//	with f in #issues do => { 			sys_listtypes !>> #f ? include('types/issues/'+#f+'.lasso') 			}
//	with f in #miscellaneous do => { 	sys_listtypes !>> #f ? include('types/miscellaneous/'+#f+'.lasso') 	}
//	with f in #orgs do => { 			sys_listtypes !>> #f ? include('types/orgs/'+#f+'.lasso') 			}
//	with f in #pulls do => { 			sys_listtypes !>> #f ? include('types/pulls/'+#f+'.lasso') 			}
	
]