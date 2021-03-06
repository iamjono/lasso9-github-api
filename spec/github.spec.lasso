// This should let us run this anywhere and still properly import the file
local(path_here) = currentCapture->callsite_file->stripLastComponent
not #path_here->beginsWith('/')? #path_here = io_file_getcwd + '/' + #path_here
not #path_here->endsWith('/')  ? #path_here->append('/')
if(not var_defined('_gh_loaded')) => {
    sourcefile(file(#path_here + `spec_helper.lasso`), -autoCollect=false)->invoke
}

describe(::github) => {
    it(`allows for setting "public" for no authentication`) => {
        expect->errorCode(error_code_noError) => {
            local(gh) = github(`public`)
        }
        expect(`public`, #gh->_authType)
    }
    it(`allows for setting the allowed authentication types`) => {
        expect(`basic`     , github(`basic`)     ->_authType)
        expect(`token`     , github(`token`)     ->_authType)
        expect(`key_secret`, github(`key_secret`)->_authType)
    }

    it(`throws an error for an unrecognized auth method`) => {
        expect->errorCode(error_code_invalidParameter) => {
            github(`BadAuth` + math_random(0,9))
        }
    }

    describe(`-> _prepareRequest`) => {
        context(`using basic authentication`) => {
            it(`properly sets up the username and password`) => {
                local(req) = github(
                    `basic`,
                    -username="uname",
                    -password="pword"
                )->_prepareRequest(http_request)

                expect(`uname`, #req->username)
                expect(`pword`, #req->password)
                expect(#req->basicAuthOnly)
            }
        }
        context(`using key_secret authentication`) => {
            it(`properly sets up the GET params`) => {
                local(req) = github(
                    `key_secret`,
                    -clientId="key",
                    -clientSecret="secret"
                )->_prepareRequest(http_request)


                expect(1, #req->getParams->find(pair(`client_id`='key'))->size)
                expect(1, #req->getParams->find(pair(`client_secret`='secret'))->size)
            }
            it(`preserves other GET params`) => {
                local(req) = github(
                    `key_secret`,
                    -clientId="key",
                    -clientSecret="secret"
                )->_prepareRequest(http_request(
                    `example.com`,
                    -getParams=(:`rhino`=`manners`)
                ))

                expect(1, #req->getParams->find(pair(`client_id`='key'))->size)
                expect(1, #req->getParams->find(pair(`client_secret`='secret'))->size)
                expect(1, #req->getParams->find(pair(`client_id`='key'))->size)
                expect(1, #req->getParams->find(pair(`rhino`='manners'))->size)
            }
        }
    }

    describe(`When ->_unknownTag calls a sub-type action`) => {
        it(`returns a github_request when the action returns an http_request`) => {
            local(result) = github(`public`)->testHelper->gitRequest

            expect(::github_request, #result->type)
        }
        it(`returns a github_result when the action returns a staticarray wih true being the second param`) => {
            local(result) = github(`public`)->testHelper->gitResult

            expect(::github_result, #result->type)
        }
        it(`returns a github_result when the action returns a staticarray wih false being the second param`) => {
            local(result) = github(`public`)->testHelper->gitResultF

            expect(::github_request, #result->type)
        }
        it(`returns the value of executing a capture passed as the second parameter of the staticarray`) => {
            local(result) = github(`public`)->testHelper->intValue

            expect(::integer, #result->type)
            expect(42       , #result)
        }
        it(`passes a github_result as the first parameter to the capture passed as the second parameter of the staticarray`) => {
            local(result) = github(`public`)->testHelper->firstParam
            
            expect(::github_result, #result)
        }
    }
}