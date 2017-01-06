class Api::ApiController < ApplicationController
	rescue_from RablRails::Library::UnknownFormat, with: :unknown_format
	rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

	private
		def unknown_format
			render plain: "unknown format: add suffix .xml or .json", status: :not_acceptable
		end

		def record_not_found
			render plain: "404 not found", status: 404
		end
end
