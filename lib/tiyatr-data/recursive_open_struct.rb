module TiyatrData
  class RecursiveOpenStruct
    # options:
    #   :exclude => [keys] - keys need to be symbols 
    def initialize(hash, options = {})
      convert_hash_to_ostruct_recursive(hash, options) 
    end

    private

    def convert_hash_to_ostruct_recursive(hash, options)
      result = hash
      if result.is_a? Hash
        result = result
        result.each  do |key, val| 
          result[key] = convert_hash_to_ostruct_recursive(val, options) unless options[:exclude].try(:include?, key)
        end
        OpenStruct.new result       
      elsif result.is_a? Array
         result.map { |r| convert_hash_to_ostruct_recursive(r, options) }
      end
    end
  end
end