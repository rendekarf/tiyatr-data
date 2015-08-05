module TiyatrData

	class Model
		
		class << self

			private

			def handle_exception e, result
				error = JSON.parse(e.response)['error']
				OpenStruct.new code: error['statusCode'] || error['status'], result: result, message: error['message']
			end

			def build_api_response response
				if response.class == String
					if response == 'null' || response == ''
						result = nil
					else
						parsed_response = JSON.parse(response)
						result = (parsed_response.class == Hash ? OpenStruct.new(parsed_response) : parsed_response.map{|res| OpenStruct.new(res)})
					end
					OpenStruct.new code: response.code, result: result
				else
					response
				end
			end

			def has_many resources
				define_singleton_method "list_#{resources.to_s.pluralize}" do |*splat|
					id = splat.first
					if splat.length == 1
						params = {}
					elsif splat.empty?
						id = nil
					else
						params = splat.last
					end

					params.select!{|k, v| Filters.include?(k.to_sym)}

					begin
						if(id.present?)
							response = RestClient.get(
								self.to_api_path + "/#{id}/#{resources.to_s.pluralize}",
								params: {filter: params.to_json},
								'Authorization' => TiyatrData.config.access_token
							)
						else
							response = {code: StatusCode::BadRequest, result: [], message: 'ID not present'}
						end
					rescue Exception => e
						handle_exception e, []
					else
						build_api_response(response)
					end
				end

				define_singleton_method "count_#{resources.to_s.pluralize}" do |*splat|
					id = splat.first
					if splat.length == 1
						params = {}
					elsif splat.empty?
						id = nil
					else
						params = splat.last
					end
					params.select!{|k, v| k.to_sym == :where}

					begin
						if(id.present?)
							response = RestClient.get(
								self.to_api_path + "/#{id}/#{resources.to_s.pluralize}/count",
								params: {filter: params.to_json},
								'Authorization' => TiyatrData.config.access_token
							)
						else
							response = {code: StatusCode::BadRequest, result: nil, message: 'ID not present'}
						end
					rescue Exception => e
						handle_exception e, nil
					else
						build_api_response(response)
					end
				end

				define_singleton_method "fetch_#{resources.to_s.singularize}" do |id, fk|
					begin
						if(id.present? && fk.present?)
							response = RestClient.get(
								self.to_api_path + "/#{id}/#{resources.to_s.pluralize}/#{fk}",
								'Authorization' => TiyatrData.config.access_token
							)
						else
							response = {code: StatusCode::BadRequest, result: nil, message: 'Both resource ids need to be present'}
						end
					rescue Exception => e
						handle_exception e, nil
					else
						build_api_response(response)
					end
				end

				#define_singleton_method "delete_#{resources.to_s.singularize}" do |id, fk|
				#	begin
				#		if(id.present? && fk.present?)
				#			response = RestClient.delete(
				#				self.to_api_path + "/#{id}/#{resources.to_s.pluralize}/#{fk}",
				#				'Authorization' => TiyatrData.config.access_token
				#			)
				#		else
				#			response = {code: StatusCode::BadRequest, result: nil, message: 'Both resource ids need to be present'}
				#		end
				#	rescue Exception => e
				#		handle_exception e, nil
				#	else
				#		build_api_response(response)
				#	end
				#end

				define_singleton_method "delete_#{resources.to_s.singularize}_link" do |id, fk|
					begin
						if(id.present? && fk.present?)
							response = RestClient.delete(
								self.to_api_path + "/#{id}/#{resources.to_s.pluralize}/rel/#{fk}",
								'Authorization' => TiyatrData.config.access_token
							)
						else
							response = {code: StatusCode::BadRequest, result: nil, message: 'Both resource ids need to be present'}
						end
					rescue Exception => e
						handle_exception e, nil
					else
						build_api_response(response)
					end
				end

				define_singleton_method "create_#{resources.to_s.singularize}" do |*splat|
					id = splat.first
					if splat.length == 1
						data = {}
					elsif splat.empty?
						id = nil
					else
						data = splat.last
					end

					begin
						if(id.present? && data.present?)
							response = RestClient.post(
								self.to_api_path + "/#{id}/#{resources.to_s.pluralize}",
								data.to_json,
								'Authorization' => TiyatrData.config.access_token,
								content_type: :json
							)
						else
							response = {code: StatusCode::BadRequest, result: nil, message: 'Both resource ids need to be present'}
						end
					rescue Exception => e
						handle_exception e, nil
					else
						build_api_response(response)
					end
				end

				#define_singleton_method "update_#{resources.to_s.singularize}" do |*splat|
				#	id = splat.first
				#	if splat.length == 1
				#		fk = nil
				#		data = {}
				#	elsif splat.length == 2
				##		fk = splat[1]
				#		data = {}
				#	elsif splat.empty?
				#		id = nil
				#	else
				#		fk = splat[1]
				#		data = splat.last
				#	end
				#
				#	begin
				#		if(id.present? && fk.present?)
				#			response = RestClient.put(
				#				self.to_api_path + "/#{id}/#{resources.to_s.pluralize}/#{fk}",
				#				data,
				#				'Authorization' => TiyatrData.config.access_token
				#			)
				#		else
				#			response = {code: StatusCode::BadRequest, result: nil, message: 'Both resource ids need to be present'}
				#		end
				#	rescue Exception => e
				#		handle_exception e, nil
				#	else
				#		build_api_response(response)
				#	end
				#end

				define_singleton_method "update_#{resources.to_s.singularize}_link" do |*splat|
					id = splat.first
					if splat.length == 1
						fk = nil
						data = {}
					elsif splat.length == 2
						fk = splat[1]
						data = {}
					elsif splat.empty?
						id = nil
					else
						fk = splat[1]
						data = splat.last
					end

					begin
						if(id.present? && fk.present?)
							response = RestClient.put(
								self.to_api_path + "/#{id}/#{resources.to_s.pluralize}/rel/#{fk}",
								data,
								'Authorization' => TiyatrData.config.access_token
							)
						else
							response = {code: StatusCode::BadRequest, result: nil, message: 'Both resource ids need to be present'}
						end
					rescue Exception => e
						handle_exception e, nil
					else
						build_api_response(response)
					end
				end
			end

			def belongs_to resource
				define_singleton_method "fetch_#{resource.to_s.singularize}" do |id|
					begin
						if(id.present?)
							response = RestClient.get(
								self.to_api_path + "/#{id}/#{resource.to_s.singularize}",
								'Authorization' => TiyatrData.config.access_token
							)
						else
							response = {code: StatusCode::BadRequest, result: nil, message: 'ID not present'}
						end
					rescue Exception => e
						handle_exception e, nil
					else
						build_api_response(response)
					end
				end
			end

			def has_one resource
				define_singleton_method "fetch_#{resource.to_s.singularize}" do |id|
					begin
						if(id.present?)
							response = RestClient.get(
								self.to_api_path + "/#{id}/#{resource.to_s.singularize}",
								'Authorization' => TiyatrData.config.access_token
							)
						else
							response = {code: StatusCode::BadRequest, result: nil, message: 'ID not present'}
						end
					rescue Exception => e
						handle_exception e, nil
					else
						build_api_response(response)
					end
				end

				define_singleton_method "create_#{resource.to_s.singularize}" do |*splat|
					id = splat.first
					if splat.length == 1
						data = {}
					elsif splat.empty?
						id = nil
					else
						data = splat.last
					end

					begin
						if(id.present?)
							response = RestClient.post(
								self.to_api_path + "/#{id}/#{resource.to_s.singularize}",
								data,
								'Authorization' => TiyatrData.config.access_token
							)
						else
							response = {code: StatusCode::BadRequest, result: nil, message: 'ID not present'}
						end
					rescue Exception => e
						handle_exception e, nil
					else
						build_api_response(response)
					end
				end

				define_singleton_method "update_#{resource.to_s.singularize}" do |*splat|
					id = splat.first
					if splat.length == 1
						data = {}
					elsif splat.empty?
						id = nil
					else
						data = splat.last
					end

					begin
						if(id.present?)
							response = RestClient.put(
								self.to_api_path + "/#{id}/#{resource.to_s.singularize}",
								data,
								'Authorization' => TiyatrData.config.access_token
							)
						else
							response = {code: StatusCode::BadRequest, result: nil, message: 'ID not present'}
						end
					rescue Exception => e
						handle_exception e, nil
					else
						build_api_response(response)
					end
				end

				define_singleton_method "delete_#{resource.to_s.singularize}_link" do |id|
					begin
						if(id.present?)
							response = RestClient.put(
								self.to_api_path + "/#{id}/#{resource.to_s.singularize}",
								{"#{self.to_s.split('::').last.underscore.singularize}_id" => nil},
								'Authorization' => TiyatrData.config.access_token
							)
						else
							response = {code: StatusCode::BadRequest, result: nil, message: 'ID not present'}
						end
					rescue Exception => e
						handle_exception e, nil
					else
						build_api_response(response)
					end
				end
			end

			public

			def list params = {}
				params.select!{|k, v| Filters.include?(k.to_sym)}
				
				response = RestClient.get(
					self.to_api_path,
					params: {filter: params.to_json},
					'Authorization' => TiyatrData.config.access_token
				)
			rescue Exception => e
				handle_exception e, []
			else
				build_api_response response
			end

			def fetch id = nil, params = {}
				if(id.present?)
					params = params.select{|k, v| [:fields, :include].include?(k.to_sym)}

					response = RestClient.get(
						self.to_api_path + "/#{id}",
						params: {filter: params.to_json},
						'Authorization' => TiyatrData.config.access_token
					)
				else
					response = {code: StatusCode::BadRequest, result: nil, message: 'ID not present'}
				end
			rescue Exception => e
				handle_exception e, nil
			else
				build_api_response(response)
			end

			def exists id = nil
				if(id.present?)
					response = RestClient.get(
						self.to_api_path + "/#{id}/exists",
						'Authorization' => TiyatrData.config.access_token
					)
				else
					response = {code: StatusCode::BadRequest, result: nil, message: 'ID not present'}
				end
			rescue Exception => e
				handle_exception e, nil
			else
				build_api_response(response)
			end

			def count params = {}
				params.select!{|k, v| k.to_sym == :where}
				
				response = RestClient.get(
					self.to_api_path + '/count',
					params: {filter: params.to_json},
					'Authorization' => TiyatrData.config.access_token
				)
			rescue Exception => e
				handle_exception e, nil
			else
				build_api_response response
			end

			def findOne params = {}
				params.select!{|k, v| Filters.include?(k.to_sym)}

				response = RestClient.get(
					self.to_api_path + '/findOne',
					params: {filter: params.to_json},
					'Authorization' => TiyatrData.config.access_token
				)
			rescue Exception => e
				handle_exception e, nil
			else
				build_api_response response
			end

			def create data = {}
				if(data.empty?)
					response = {code: StatusCode::BadRequest, result: nil, message: 'No payload'}
				else
					response = RestClient.post(
						self.to_api_path,
						data.to_json,
						'Authorization' => TiyatrData.config.access_token,
						content_type: :json
					)
				end
			rescue Exception => e
				handle_exception e, nil
			else
				build_api_response(response)
			end

			def destroy id = nil
				if(id.present?)
					response = RestClient.delete(
						self.to_api_path + "/#{id}",
						'Authorization' => TiyatrData.config.access_token
					)
				else
					response = {code: StatusCode::BadRequest, result: nil, message: 'ID not present'}
				end
			rescue Exception => e
				handle_exception e, nil
			else
				build_api_response(response)
			end

			def update id = nil, data = {}
				if(id.present?)
					response = RestClient.put(
						self.to_api_path + "/#{id}",
						data,
						'Authorization' => TiyatrData.config.access_token
					)
				else
					response = {code: StatusCode::BadRequest, result: nil, message: 'ID not present'}
				end
			rescue Exception => e
				handle_exception e, nil
			else
				build_api_response(response)
			end

			def bulk_update data = {}, params = {}
				params.select!{|k, v| k.to_sym == :where}

				if(data.empty?)
					response = {code: StatusCode::BadRequest, result: [], message: 'No payload'}
				else
					response = RestClient.post(
						self.to_api_path + '/update',
						{params: {where: params[:where].to_json}},
						data,
						'Authorization' => TiyatrData.config.access_token
					)
				end
			rescue Exception => e
				handle_exception e, []
			else
				build_api_response(response)
			end

			def to_api_path
				TiyatrData.config.api_root + '/' + self.to_s.split('::').last.underscore.pluralize
			end
		end
	end
end