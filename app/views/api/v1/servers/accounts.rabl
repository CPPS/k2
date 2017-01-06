object :@server
extends 'api/v1/servers/base'
child(:accounts, partial: 'api/v1/accounts/base')
