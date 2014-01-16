[
/* =======================================================================
	Gists API
	
		Authentication
			You can read public gists and create them for anonymous users 
			without a token; however, to read or write gists on a user’s 
			behalf the gist OAuth scope is required.
		List gists
		Get a single gist
		Create a gist
		Edit a gist
		Star a gist
		Unstar a gist
		Check if a gist is starred
		Fork a gist
		Delete a gist
======================================================================= */
define github_gists => type {
	data
		public request::http_request    = http_request,
		public contents::array			= array

	/* =================================================================================================
	List gists
		List a user’s gists:
			GET /users/:user/gists
			.list(-user='iamjono')
			
		List the authenticated user’s gists or if called anonymously, this will return all public gists:
			GET /gists
			.list()
			or for an authenticated users gists
			.token('mytoken')
			.list()

		List all public gists:
			GET /gists/public
			.list(-public)
		
		List the authenticated user’s starred gists:
			GET /gists/starred
			.list(-starred)
		
	Params:
		since
			Optional string of a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ Only gists updated at 
			or after this time are returned.
	================================================================================================= */
	public list(user::string, -since=void) => {
		.request->urlPath = '/users/' + #user + '/gists'

		#since->isA(::date)
			? .request->getParams = (:#since->format('yyyy-MM-ddHH:mm:ssZ'))
		return .request
	}
	public list(
		-public ::boolean=false,
		-starred::boolean=false,
		-since=void
	) => {
		#public
			? .request->urlPath = '/gists/public'
		| #starred
			? .request->urlPath = '/gists/starred'
		| .request->urlPath = '/gists'

		#since->isA(::date)
			? .request->getParams = (:#since->format('yyyy-MM-ddHH:mm:ssZ'))

		return .request
	}
	
	public get(id) => {
		.request->urlPath = '/gists/' + #id->asString
		return .request
	}

}

/*
comments: 0
comments_url: https://api.github.com/gists/7489893/comments
commits_url: https://api.github.com/gists/7489893/commits
created_at: 2013-11-15T19:10:18Z
description: wkhtmltopdf type
https://code.google.com/p/wkhtmltopdf/
wkhtmltopdf('http://www.example.com/mypage.lasso?id=83','/pdfcache/id83.pdf',-removelast)
Requires std_shellhandler trait
files: map(wkhtmltopdf.lasso = map(filename = wkhtmltopdf.lasso, language = Lasso, raw_url = https://gist.github.com/iamjono/7489893/raw/a6e5d147af192931d2c28bdf592acddc0bbd5173/wkhtmltopdf.lasso, size = 2347, type = text/plain))
forks_url: https://api.github.com/gists/7489893/forks
git_pull_url: https://gist.github.com/7489893.git
git_push_url: https://gist.github.com/7489893.git
html_url: https://gist.github.com/7489893
id: 7489893
public: true
updated_at: 2013-11-15T19:10:19Z
url: https://api.github.com/gists/7489893
user: map(avatar_url = https://gravatar.com/avatar/cf6529acf8fd49f9e08fc756f5b9c90e?d=https%3A%2F%2Fidenticons.github.com%2Fa80cc21aa462cac9e6f20e69bef733f8.png&r=x, events_url = https://api.github.com/users/iamjono/events{/privacy}, followers_url = https://api.github.com/users/iamjono/followers, following_url = https://api.github.com/users/iamjono/following{/other_user}, gists_url = https://api.github.com/users/iamjono/gists{/gist_id}, gravatar_id = cf6529acf8fd49f9e08fc756f5b9c90e, html_url = https://github.com/iamjono, id = 3789179, login = iamjono, organizations_url = https://api.github.com/users/iamjono/orgs, received_events_url = https://api.github.com/users/iamjono/received_events, repos_url = https://api.github.com/users/iamjono/repos, site_admin = false, starred_url = https://api.github.com/users/iamjono/starred{/owner}{/repo}, subscriptions_url = https://api.github.com/users/iamjono/subscriptions, type = User, url = https://api.github.com/users/iamjono)
*/

define gh_gist => type {
	data 
		public comments::integer,
		public comments_url::string,
		public commits_url::string,
		public created_at::date,
		public description::string,
		public files::map,
		public forks_url::string,
		public git_pull_url::string,
		public git_push_url::string,
		public html_url::string,
		public id::string,
		public ispublic::boolean,
		public updated_at::date,
		public url::string,
		public user::map
		
	public convert(a::array) => {
		local(contents = array)
		with i in #a do => {
			local(gist = gh_gist)
			#gist->convert(#i)
			#contents->insert(#gist)
		}
		return #contents
	}
	public convert(i::map) => {
		with e in #i->keys do => {
			match(#e) => {
				case('comments')
					.comments = integer(#i->find(#e)) 
				case('comments_url')
					.comments_url = #i->find(#e) 
				case('created_at')
					.created_at = date(#i->find(#e)) 
				case('description')
					.description = #i->find(#e) 
				case('files')
					.files = #i->find(#e) 
				case('forks_url')
					.forks_url = #i->find(#e) 
				case('git_pull_url')
					.git_pull_url = #i->find(#e) 
				case('git_push_url')
					.git_push_url = #i->find(#e) 
				case('html_url')
					.html_url = #i->find(#e) 
				case('id')
					.id = #i->find(#e) 
				case('public')
					.ispublic = #i->find(#e) 
				case('updated_at')
					.updated_at = date(#i->find(#e)) 
				case('url')
					.url = #i->find(#e) 
				case('user')
					.user = #i->find(#e) 
			}
		}
	}
}

]