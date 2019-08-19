module RubyRedtrack
  class Entity
    HANDLED_ENTITIES = %w(campaign lander offer traffic-source affiliate-network).freeze

    def initialize(connection)
      binding.pry
      raise "#{entity_name} is not suppoted" unless HANDLED_ENTITIES.include?(entity_name)
      @connection = connection
    end

    def all(params = {})
      binding.pry
      unless @connection.get(entity_name, params).blank?
        @connection.get(entity_name, params).values.first
      else
        "Wrong connection with the current api key"
      end
    end

    def find(id:)
      @connection.get("#{entity_name}/#{id}")
    end

    def update(id:, data:)
      @connection.put("#{entity_name}/#{id}", data)
    end

    def create(data:)
      @connection.post(entity_name, data)
    end

    def delete(ids)
      ids = ids.is_a?(Array) ? ids : [ids]
      @connection.delete(entity_name, ids: ids)
    end

    def restore(ids)
      ids = ids.is_a?(Array) ? ids : [ids]
      @connection.post("#{entity_name}/restore", ids: ids)
    end

    private

    def entity_name
      @entity_name ||= to_kebab_case(self.class.to_s)
    end

    def to_kebab_case(str)
      str.split('::').last.gsub(/[A-Z]/) { |e| "-#{e.downcase}" }[1..-1]
    end
  end
end
