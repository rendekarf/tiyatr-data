module TiyatrData

	module StatusCode
		BadRequest 			= 400
		Unauthorized 		= 401
		ResourceNotFound	= 404
		InternalServerError = 500
		OK 					= 200
		NoContent			= 204
	end

	StatusCodes	= [
		StatusCode::BadRequest,
		StatusCode::Unauthorized,
		StatusCode::ResourceNotFound,
		StatusCode::InternalServerError,
		StatusCode::OK,
		StatusCode::NoContent
	]
	
end