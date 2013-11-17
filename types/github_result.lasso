define github_result => type {
    data
        private response::http_response,
        private objectData

    // Basic Getters
    public
        response   => .`response`,
        objectData => .`objectData`

    public onCreate(response::http_response) => {
        .response   = #response
        .objectData = json_deserialize(#response->bodyString)
    }
}