define github => type {
    data
        private _reqObject         = void,
        private _authType::string  = ``,
        private _apiUrl::string    = `https://api.github.com`,
        private _validAuthTypes    = (:
                                        `public`,
                                        `basic`,
                                        `token`,
                                        `key_secret`
                                    )

    data
        public _userAgent::string    = ``,
        public _username::string     = ``,
        public _password::string     = ``,
        public _clientID::string     = '',
        public _clientSecret::string = ''

    // Basic Getters
    public
        _authType => .`_authType`,
        _apiUrl   => .`_apiUrl`

    public onCreate(
        authType::string,
        -userAgent::string=`Unknown-Lasso9-API`,
        -username::string=``,
        -password::string=``,
        -clientID::string='',
        -clientSecret::string=''
    ) => {
        ._validAuthTypes !>> #authType
            ? fail(
                error_code_invalidParameter,
                error_msg_invalidParameter + `: "` + #authType + `" is not a valid authentication method`
            )
        
        ._authType     = #authType
        ._userAgent    = #userAgent
        ._username     = #username
        ._password     = #password
        ._clientID     = #clientID
        ._clientSecret = #clientSecret
    }

    /**!
        The first time an unknown method is called, it is used to lookup the type of the
        request we are doing and stores the proper type in _reqObject. It then returns a
        copy of itself for use with that type.

        Subsequent unknown method requests are then processed as member methods of the
        object store in the _reqObject data member. Those member methods should return
        an http_request object. From there, we can add the necessary authentication
        parameters, issue the request, and return the response object.
    */
    public _unknownTag(...) => {
        if(void == ._reqObject) => {
            // The discrete types should be named github_methodName, e.g. github_gists
            .`_reqObject` = \(::github_ + method_name)->invoke

            return self->asCopy
        }

        // The method is being called on the _reqObject and should return an http_request
        local(req) = ._prepareRequest(._reqObject->\(method_name)->invoke(:#rest))

        return github_result(#req->response)
    }
    
    private _apiURL(path::string) => ._apiURL + #path

    public _prepareRequest(req::http_request)::http_request => {
        local(headers) = array

        // Should ahve a path, let's fill in the URL
        #req->url  = ._apiURL(#req->urlPath)

        // Docs say you *must* have an user agent
        #headers->insert(`User-Agent`=._userAgent)

        // Deal with Authentication
        match(._authType) => {
        case(`basic`)
            #req->username      = ._username
            #req->password      = ._password
            #req->basicAuthOnly = true
        case(`key_secret`)
            #req->getParams += (:`client_id`=._clientID, `client_secret`=._clientSecret)
        }

        return #req
    }
}