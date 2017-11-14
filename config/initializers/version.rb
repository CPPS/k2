Rails.application.config.version = if File.exist? 'version'
                                    File.read('version')
                                   else
                                    'UNVERSIONED'
                                   end
