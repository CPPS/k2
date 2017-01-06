object :@server
extends 'api/v1/servers/base'
child(:problems, partial: 'api/v1/problems/base')
