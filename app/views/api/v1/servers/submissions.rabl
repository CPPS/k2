object :@server
extends 'api/v1/servers/base'
child(:submissions, partial: 'api/v1/submissions/base')
