/**!
    This type is returned after the resource request and authentication has been
    setup. It handles making the request when the user asks it to.

    TODO:
        Allow for adding pagination
            (from the docs, might mean changing the URL to one specified in the Link: header of a response)
**/
define github_request => type {
    data
        private request::http_request

    public onCreate(request::http_request) => {
        .request   = #request
    }

    public response => github_result(.request->response)
    public invoke   => .response
}