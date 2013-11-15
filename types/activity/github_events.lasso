[
/* =======================================================================
	This is a read-only API to the GitHub events. 
	These events power the various activity streams on the site.
		List public events
		List repository events
		List issue events for a repository
		List public events for a network of repositories
		List public events for an organization
		List events that a user has received
		List public events that a user has received
		List events performed by a user
		List public events performed by a user
		List events for an organization
		
		Events are optimized for polling with the “ETag” header. 
		If no new events have been triggered, you will see a “304 Not Modified” response, 
		and your current rate limit will be untouched. There is also an “X-Poll-Interval” header 
		that specifies how often (in seconds) you are allowed to poll. In times of high server 
		load, the time may increase. Please obey the header.
======================================================================= */
define github_events => type {
	parent github_parent
	data
		public objectdata::array		= array
}
]