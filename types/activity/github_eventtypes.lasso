[
/* =======================================================================
	Each event has a similar JSON schema, but a unique payload object that 
	is determined by its event type. Repository hook names relate to event 
	types, and will have the exact same payload. The only exception to this 
	is the push hook, which has a larger, more detailed payload.

	This describes just the payload of an event. A full event will also show 
	the user that performed the event (actor), the repository, and the 
	organization (if applicable).

	Note that some of these events may not be rendered in timelines. 
	They’re only created for various internal and repository hooks.
	
		CommitCommentEvent
		CreateEvent
		DeleteEvent
		DownloadEvent
		FollowEvent
		ForkEvent
		ForkApplyEvent
		GistEvent
		GollumEvent
		IssueCommentEvent
		IssuesEvent
		MemberEvent
		PublicEvent
		PullRequestEvent
		PullRequestReviewCommentEvent
		PushEvent
		ReleaseEvent
		StatusEvent
		TeamAddEvent
		WatchEvent
======================================================================= */
define github_eventtypes => type {
	trait { import github_common }	
	data
		protected prefix::string	= 'result_',
		protected u::string 		= string,
		protected p::string 		= 'x-oauth-basic',
		public user::string			= '',
		public objectdata::array	= array,
		public headers				= github_header,
		public url::string			= string


	
}
]