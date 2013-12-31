[
	sys_listunboundmethods !>> 'br' ? define br => '<br>'
	
	// http_request and http_response objects
	sys_listtypes !>> 'http_request' ? lassoapp_include('Lasso_HTTP/http_request.lasso')
	sys_listtypes !>> 'http_response' ? lassoapp_include('Lasso_HTTP/http_response.lasso')

	lassoapp_include('types/github.lasso')
	lassoapp_include('types/github_request.lasso')
	lassoapp_include('types/github_result.lasso')
		
	// user object
	lassoapp_include('types/main/github_user.lasso')
	
	// repos object
	lassoapp_include('types/repos/github_repos.lasso')
//	
	local(
		repos = array(
			'github_contents'
		),
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
	with f in #activity do => { 		sys_listtypes !>> #f ? lassoapp_include('types/activity/'+#f+'.lasso') 		}
	with f in #gists do => { 			sys_listtypes !>> #f ? lassoapp_include('types/gists/'+#f+'.lasso') 			}
	with f in #gitdata do => { 			sys_listtypes !>> #f ? lassoapp_include('types/gitdata/'+#f+'.lasso') 			}
	with f in #issues do => { 			sys_listtypes !>> #f ? lassoapp_include('types/issues/'+#f+'.lasso') 			}
	with f in #miscellaneous do => { 	sys_listtypes !>> #f ? lassoapp_include('types/miscellaneous/'+#f+'.lasso') 	}
	with f in #orgs do => { 			sys_listtypes !>> #f ? lassoapp_include('types/orgs/'+#f+'.lasso') 			}
	with f in #pulls do => { 			sys_listtypes !>> #f ? lassoapp_include('types/pulls/'+#f+'.lasso') 			}
	
]